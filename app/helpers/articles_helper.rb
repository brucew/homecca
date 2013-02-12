module ArticlesHelper

  def article_share_tag(article)
    html = '<span>'
    html << facebook_share_tag(article_url(article))
    html << twitter_share_tag(article.title, article_url(article))
    html << link_to(image_tag('/icons/mail.png', :size => '18x18', :style => 'margin:0px 0px 0px 2px'), new_share_path(:article_id => article.id),
                    :popup => ['Share this article', 'height=250,width=800,resizable=yes'])
    html << '</span>'
    html
  end

end
