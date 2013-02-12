module Notify
  require 'offer_comment'
  require 'offer'
  require 'request'
  require 'todo_item'
  require 'user'

#-- Notifications ---------------------------------------------------

  def Notify.offer_comment_create(offer_comment)
    Mailer.send_later :deliver_mimi_offer_comment_created, offer_comment
  end

  def Notify.offer_create(offer)
    Mailer.send_later :deliver_mimi_offer_created, offer
  end

  def Notify.offer_update(offer)
    Mailer.send_later :deliver_mimi_offer_updated, offer
  end

  def Notify.offer_destroy(offer)
    Mailer.send_later :deliver_mimi_offer_removed, offer
  end

  def Notify.offer_accept(offer)
    Delayed::Job.enqueue OfferAcceptNotificationJob.new(offer)
  end

  def Notify.offer_reject(offer, reason)
    Mailer.send_later :deliver_mimi_offer_rejected, offer, reason
  end

  def Notify.request_create(request)
    Delayed::Job.enqueue RequestCreateNotificationJob.new(request)
  end

  def Notify.request_update(request)
    Delayed::Job.enqueue RequestUpdateNotificationJob.new(request)
  end

  def Notify.request_destroy(active_offers, request)
    Delayed::Job.enqueue RequestDestroyNotificationJob.new(active_offers, request)
  end

  def Notify.request_complete(request)
    Delayed::Job.enqueue RequestCompleteNotificationJob.new(request)
  end

  def Notify.user_facebook_connect(user)
    Delayed::Job.enqueue UserFacebookConnectNotificationJob.new(user)
  end

  def Notify.remind(user, todo_items)
    reminder_list = todo_items.collect{|i| i.name}.join(', ')
    Mailer.send_later :deliver_mimi_reminder, user, reminder_list
  end

  def Notify.past_due(user, todo_items)
    past_due_list = todo_items.collect{|i| i.name}.join(', ')
    Mailer.send_later :deliver_mimi_past_due_summary, user, past_due_list
  end

#-- Jobs ------------------------------------------------------------

  class OfferAcceptNotificationJob < Struct.new(:accepted_offer)
    def perform
      Mailer.send_later :deliver_mimi_offer_accepted_provider, accepted_offer
      Mailer.send_later :deliver_mimi_offer_accepted_requester, accepted_offer
#    This assumes that no offers were closed before one was accepted
      accepted_offer.request.offers.each do |offer|
        Mailer.send_later(:deliver_mimi_offer_not_accepted, offer) if offer.state == :closed
      end
    end
  end

  class RequestCreateNotificationJob < Struct.new(:request)
#    These are here to generate the request URL
    include ActionController::UrlWriter
    default_url_options[:host] = ActionMailer::Base.default_url_options[:host]

    def perform
      loc = Geokit::LatLng.new(request.lat, request.lng)

      providers = Provider.tagged_with(request.job_type, :any => true).near(loc)
      providers.delete(request.requester)
      providers.each do |provider|
        Mailer.send_later :deliver_mimi_request_created, provider, request
      end

      begin
        Notify::facebook_post(request.requester, 'is looking for help with ' + request.name, request_url(request))
      rescue
        Log.log('FACEBOOK: request create post failed for request ' + request.id.to_s)
      end
    end
  end

  class RequestUpdateNotificationJob < Struct.new(:request)
    def perform
      offerers = request.offers.active.collect { |offer| offer.offerer }
      offerers.each do |offerer|
        Mailer.send_later :deliver_mimi_request_updated, offerer, request
      end
    end
  end

  class RequestDestroyNotificationJob < Struct.new(:active_offers, :request)
    def perform
      offerers = active_offers.collect { |offer| offer.offerer }
      offerers.each do |offerer|
        Mailer.send_later :deliver_mimi_request_removed, offerer, request
      end
    end
  end

  class RequestCompleteNotificationJob < Struct.new(:request)
    def perform
      Mailer.send_later :deliver_mimi_request_completed, request

      begin
        Notify::facebook_post(request.provider, 'has successfully completed the "' + request.name + '" job!')
        Notify::facebook_post(request.requester, 'got help with "' + request.name + '"')
      rescue
        Log.log('FACEBOOK: request complete post failed for request ' + request.id.to_s)
      end
    end
  end

  class UserFacebookConnectNotificationJob < Struct.new(:user)
    def perform
      begin
        Notify::facebook_post(user, 'joined the Homecca community')
      rescue
        Log.log('FACEBOOK: user connect post failed for user ' + user.id.to_s)
      end
    end
  end

#-- Notification utilities ----------------------------------------------

  def Notify.facebook_post(user, comment, url = ActionMailer::Base.default_url_options[:host])
    if user.facebook_uid and user.facebook_session
      @fb = MiniFB::Session.new(BlueLightSpecial.configuration.facebook_api_key,
                                BlueLightSpecial.configuration.facebook_secret_key,
                                user.facebook_session,
                                user.facebook_uid)
      fb_response = @fb.call('links.post', {'url' => url, 'comment' => comment, 'format' => ''})
      Log.log('FACEBOOK: posted to ' + user.name + '[' + user.id.to_s + ']')
    end
  end

end