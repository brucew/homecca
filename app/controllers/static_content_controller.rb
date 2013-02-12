class StaticContentController < ApplicationController
  skip_before_filter :authenticate

  def welcome
    @fb = Utility::FacebookMetadata.new(
        :title       => 'Homecca',
        :description => 'Home maintenance made easy',
        :image_url   => 'http://www.homecca.com/images/homecca_logo.png'
    )
    render :action => 'welcome', :layout => 'newt'
  end

  def faq    
    @fb = Utility::FacebookMetadata.new(
        :title       => 'Homecca',
        :description => 'Home maintenance made easy',
        :image_url   => 'http://www.homecca.com/images/homecca_logo.png'
    )
    render :action => 'faq', :layout => 'newt'
  end

end
