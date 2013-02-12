class HomeController < ApplicationController

  def home
    @user = User.find(current_user.id)
  end
  
  def settings
    @myhome = "myhome"
    @user = User.find(current_user.id)
    
    render :layout => "newt"
  end
  
end