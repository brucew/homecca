module RatingsHelper

  def rating_tag(rating)
    html = ''
    if rating == 0
      5.times do
        html << image_tag('/icons/star_small_empty.png')
      end
    else
      #is there a half star?
      half = rating % 1
        #get number of full stars
      full = rating.floor.to_i
        #render full stars
      full.times do
        html << image_tag('/icons/star_small.png')
      end
      if half >= 0.5
        html << image_tag('/icons/star_small_half.png')
      end
      rounded_half = half.ceil.to_i
      (5 - full - rounded_half).times do
        html << image_tag('/icons/star_small_empty.png')
      end
    end
    return html
  end

end
