# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include SortableTable::App::Helpers::ApplicationHelper

  def datetime_display(from_time, to_time = Time.now, include_seconds = true, detail = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
    case distance_in_minutes
      when 0..1 then
        time = 'a minute ago'
      when 2..59 then
        time = "#{distance_in_minutes} minutes ago"
      when 60..89 then
        time = 'an hour ago'
      when 90..1440 then
        time = "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      when 1440..2160 then
        time = 'a day ago' # 1-1.5 days
      when 2160..14400 then
        time = "#{(distance_in_minutes.to_f / 1440.0).round} days ago" # 1.5-2 days
      else
        time = from_time.to_datetime.strftime("%b %d %Y").squeeze(' ')
    end
    return time_stamp(from_time) if (detail && distance_in_minutes > 2880)
    return time
  end

  def compensation_tag(obj)
    html = ''
    if obj.paid?
      html << image_tag('/icons/dollar.jpg', :title => 'paid', :alt => 'paid', :size => '20x19', :style => 'vertical-align:middle;')
      html << ' paid &nbsp;'
    end
    if obj.trade?
      html << image_tag('/icons/handshake.jpg', :title => 'trade', :alt => 'trade', :size => '24x24', :style => 'vertical-align:middle;')
      html << ' trade &nbsp;'
    end
    if obj.volunteer?
      html << image_tag('/icons/heart.png', :title => 'volunteer', :alt => 'volunteer', :size => '16x16', :style => 'vertical-align:middle;')
      html << ' volunteer &nbsp;'
    end
    return html
  end

  def compensation_icon_tag(obj)
    html = ''
    if obj.paid
      html << image_tag('/icons/dollar.jpg', :name => 'paid', :alt => 'paid', :size => '14x14')
    end
    if obj.trade
      html << image_tag('/icons/handshake.jpg', :name => 'trade', :alt => 'trade', :size => '16x18')
    end
    if obj.volunteer
      html << image_tag('/icons/heart-small.png', :name => 'volunteer', :alt => 'volunteer')
    end
    return html
  end

  def facebook_share_tag(url)
    link_to image_tag('/icons/facebook.png', :size => '16x16', :style => 'margin:2px 2px 0 2px'),
            'http://www.facebook.com/sharer.php?u=' + url_encode(url)
  end

  def twitter_share_tag(title, url)
    link_to image_tag('/icons/twitter.png', :size => '16x16', :style => 'margin:2px 2px 0 2px'),
            'http://twitter.com/home?status=' + title + ' ' + url_encode(url)
  end

end
