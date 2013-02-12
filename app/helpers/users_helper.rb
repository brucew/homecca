module UsersHelper

  def avatar_tag(user, opts = {})
    opts[:alt] = user.name
    opts[:title] = user.name
    opts[:class] = 'avatar' unless opts[:class]

    html = []
    case opts[:size]
      when :thumb
        opts[:size] = User::AVATAR_THUMB_SIZE
        html << image_tag(user.avatar.url(:thumb), opts)
      when :mid
        opts[:size] = User::AVATAR_MID_SIZE
        html << '<span class="image_shadow_container">'
        html << image_tag(user.avatar.url, opts)
        html << image_tag('/clockstone/images/image_shadow.png',
                          :width => User::AVATAR_MID_WIDTH.to_i + 10,
                          :height => User::AVATAR_MID_WIDTH.to_i / 20,
                          :class => 'noimgbg')
        html << '</span>'
      else
        html << '<span class="image_shadow_container">'
        opts[:size] = User::AVATAR_SIZE
        html << image_tag(user.avatar.url, opts)
        html << image_tag('/clockstone/images/image_shadow.png',
                          :width => User::AVATAR_WIDTH.to_i + 10,
                          :height => User::AVATAR_WIDTH.to_i / 20,
                          :class => 'noimgbg')
        html << '</span>'
    end

    return html
  end

end