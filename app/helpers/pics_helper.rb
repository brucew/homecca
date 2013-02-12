module PicsHelper

  def pic_thumb_tag(pic, opts = {})
    html         =''
    opts[:size]  = pic.size(:thumb)
    opts[:class] = 'border'
    html << link_to(image_tag(pic.url(:thumb), opts), pic.url,
                    :title => h(pic.caption), :class =>'gallery')
    html
  end

  def pic_caption_tag(pic)
    html = ''
    unless pic.caption.empty?
      html << '<small><br/>'
      html << h(pic.caption)
      html << '</small>'
    end
  end
end

