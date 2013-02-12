class Mailer < MadMimiMailer

  def mimi_request_created(provider, request)
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: New request for your skills"
    recipients provider.email
    body ({
        :recipient_name => provider.name,
        :request_name => request.name,
        :request_description => request.description,
        :request_url => request_url(request)
    })
    Log.log('EMAIL: request_created sent to ' + recipients)
  end

  def mimi_request_share(email, request)
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: New request for your skills"
    recipients email
    body ({
        :request_name => request.name,
        :request_description => request.description,
        :request_url => request_url(request)
    })
    Log.log('EMAIL: request_share sent to ' + recipients)
  end

  def mimi_request_updated(offerer, request)
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: '#{request.name}' job has changed"
    recipients offerer.email
    body ({
        :recipient_name => offerer.name,
        :request_name => request.name,
        :request_url => request_url(request)
    })
    Log.log('EMAIL: request_updated sent to ' + recipients)
  end

  def mimi_request_removed(offerer, request)
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: '#{request.name}' job has been removed"
    recipients offerer.email
    body ({
        :recipient_name => offerer.name,
        :request_name => request.name
    })
    Log.log('EMAIL: request_removed sent to ' + recipients)
  end

  def mimi_request_completed(request)
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: '#{request.name}' job completed"
    recipients request.provider.email
    body ({
        :recipient_name => request.provider.name,
        :request_name => request.name,
        :requester_name => request.requester.name,
        :score => request.rating.score.to_s,
        :request_url => request_url(request)
    })
    Log.log('EMAIL: request_completed sent to ' + recipients)
  end

  def mimi_offer_accepted_provider(offer)
    request = offer.request
    recipients offer.offerer.email
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: Congratulations, your offer on '#{request.name}' job has been selected"
    body ({
        :recipient_name => offer.offerer.name,
        :request_name => request.name,
        :request_url => request_url(request),
        :requester_name => request.requester.name,
        :requester_phone => request.requester.phone || '',
        :requester_email => request.requester.email
    })
    Log.log('EMAIL: offer_accepted sent to ' + recipients)
  end

  def mimi_offer_accepted_requester(offer)
    request = offer.request
    recipients request.requester.email
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: Contact information for #{offer.offerer.name}"
    body ({
        :recipient_name => request.requester.name,
        :request_name => request.name,
        :request_url => request_url(request),
        :provider_name => offer.offerer.name,
        :provider_phone => offer.offerer.phone || '',
        :provider_email => offer.offerer.email
    })
    Log.log('EMAIL: offer_accepted sent to ' + recipients)
  end

  def mimi_offer_not_accepted(offer)
    request = offer.request
    recipients offer.offerer.email
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: Your offer on '#{request.name}' job has been closed"
    body ({
        :recipient_name => offer.offerer.name,
        :request_name => request.name,
        :request_url => request_url(request)
    })
    Log.log('EMAIL: offer_not_accepted sent to ' + recipients)
  end

  def mimi_offer_rejected(offer, reason)
    request = offer.request
    recipients offer.offerer.email
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: Your offer on '#{request.name}' job has been closed"
    body ({
        :recipient_name => offer.offerer.name,
        :request_name => request.name,
        :request_url => request_url(request),
        :reason => reason
    })
    Log.log('EMAIL: offer_rejected sent to ' + recipients)
  end

  def mimi_offer_created(offer)
    request = offer.request
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: New offer by #{offer.offerer.name} on '#{request.name}' job"
    recipients offer.request.requester.email
    body ({
        :recipient_name => request.requester.name,
        :request_name => request.name,
        :offerer_name => offer.offerer.name,
        :offer_url => offer_url(offer)
    })
    Log.log('EMAIL: offer_created sent to ' + recipients)
  end

  def mimi_offer_updated(offer)
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: #{offer.offerer.name}'s offer on '#{offer.request.name}' job has changed"
    recipients offer.request.requester.email
    body ({
        :recipient_name => offer.request.requester.name,
        :request_name => offer.request.name,
        :offerer_name => offer.offerer.name,
        :offer_url => offer_url(offer)
    })
    Log.log('EMAIL: offer_updated sent to ' + recipients)
  end

  def mimi_offer_removed(offer)
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: Offer by #{offer.offerer.name} on '#{offer.request.name}' job was removed"
    recipients offer.request.requester.email
    body ({
        :recipient_name => offer.request.requester.name,
        :request_name => offer.request.name,
        :offerer_name => offer.offerer.name,
        :request_url => request_url(offer.request)
    })
    Log.log('EMAIL: offer_removed sent to ' + recipients)
  end

  def mimi_offer_comment_created(offer_comment)
    offer = offer_comment.offer
    request = offer.request
    from BlueLightSpecial.configuration.mailer_sender
    subject "Homecca: You have a new comment on '#{request.name}' job"

    if offer_comment.commenter == offer.offerer
      recipients request.requester.email
      recipient_name = request.requester.name
    else
      recipients offer.offerer.email
      recipient_name = offer.offerer.name
    end

    body ({
        :recipient_name => recipient_name,
        :commenter_name => offer_comment.commenter.name,
        :offerer_name => offer.offerer.name,
        :request_name => request.name,
        :offer_comment => offer_comment.comment,
        :offer_url => offer_url(offer)
    })
    Log.log('EMAIL: offer_comment_created sent to ' + recipients)
  end

  def mimi_change_password(user)
    from BlueLightSpecial.configuration.mailer_sender
    recipients user.email
    subject "Homecca: Request to change your password"
    body ({
        :recipient_name => user.name,
        :user_name => user.name,
        :change_password_url => edit_user_password_url(user, :token => user.password_reset_token, :escape => false)
    })
    Log.log('EMAIL: change_password sent to ' + recipients)
  end

  def mimi_welcome(user)
    from BlueLightSpecial.configuration.mailer_sender
    recipients user.email
    subject "Welcome to Homecca"
    body ({
        :recipient_name => user.name,
        :confirmation_url => new_user_confirmation_url(:user_id => user,
                                                       :token => user.confirmation_token,
                                                       :encode => false)
    })
    Log.log('EMAIL: welcome sent to ' + recipients)
  end

  def mimi_confirmation(user)
    from BlueLightSpecial.configuration.mailer_sender
    recipients user.email
    subject "Homecca: Account Confirmation"
    body ({
        :recipient_name => user.name,
        :confirmation_url => new_user_confirmation_url(:user_id => user,
                                                       :token => user.confirmation_token,
                                                       :encode => false)
    })
    Log.log('EMAIL: confirmation sent to ' + recipients)
  end

  def mimi_reminder(user, reminder_list)
    from BlueLightSpecial.configuration.mailer_sender
    recipients user.email
    subject "Homecca: Reminder"
    body ({
        :recipient_name => user.name,
        :reminder_list => reminder_list,
        :todo_items_url => todo_items_url
    })
    Log.log('EMAIL: reminder sent to ' + recipients)
  end

  def mimi_past_due_summary(user, past_due_list)
    from BlueLightSpecial.configuration.mailer_sender
    recipients user.email
    subject "Homecca: Past due todo items summary"
    body ({
        :recipient_name => user.name,
        :past_due_list => past_due_list,
        :todo_items_url => todo_items_url
    })
    Log.log('EMAIL: summary sent to ' + recipients)
  end

end