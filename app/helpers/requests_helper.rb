module RequestsHelper

  def request_share_tag(request)
    html = '<span>'
    html << facebook_share_tag(request_url(request))
    html << twitter_share_tag(request.name, request_url(request))
    html << link_to(image_tag('/icons/mail.png', :size => '18x18', :style => 'margin:0px 0px 0px 2px'), new_share_path(:request_id => request.id),
                    :popup => ['Share this job', 'height=300px,width=480px,resizable=yes'])
    html << '</span>'
    html
  end

  def request_state_icon_tag(request)
    case request.state
      when :open
        image_tag('/icons/magnifier.png', :alt => 'open for offers', :title => 'open for offers')
      when :offer_accepted
        image_tag('/icons/user-green.png', :alt => 'worker selected', :title => 'worker selected')
      when :completed
        image_tag('/icons/tick.png', :alt => 'completed', :title => 'completed')
    end
  end

  def request_activity_tag(request)
    html = ''
    case request.state
      when :open
        if request.offers.active.count > 0
          html << link_to('Choose a worker ' + image_tag('/icons/user-green.png'), request_path(request))
        else
          html << 'waiting for worker offers'
        end
      when :offer_accepted
        html << link_to('Close this job ' + image_tag('/icons/door.png'), close_request_path(request))
      else
        html << 'No action needed'
    end
    return html
  end

end
