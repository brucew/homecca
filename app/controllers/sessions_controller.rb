class SessionsController < BlueLightSpecial::SessionsController

#  This action is a patch for fixing a bug in cops
#  It may need to be updated if cops is upgraded
  def create
    @user = if params[:session]
              ::User.authenticate(params[:session][:email], params[:session][:password])
            else
              ::User.find_facebook_user(cookies[BlueLightSpecial.configuration.facebook_api_key + "_session_key"],
                                        cookies[BlueLightSpecial.configuration.facebook_api_key + "_user"])
            end

    case
      when @user.nil? then
        flash_failure_after_create
        #redirect_to root_path
        #render :template => 'sessions/new', :status => :unauthorized
      when (not @user.valid?) then
        session[:user_facebook_uid] = @user.facebook_uid if @user.facebook_user?
        render :template => 'users/new'
      else
        if @user.email_confirmed?
          sign_in(@user)
          @redirect_after_login =  URI(request.referer).path == '/' ? "/todo_items" : URI(request.referer).path
          flash_success_after_create
        else
          Log.log('DELAYED JOB: deliver_confirmation submitted for ' +
                      @user.name + '(' + @user.email + '), ' + @user.id.to_s)
          ::BlueLightSpecialMailer.send_later :deliver_confirmation, @user
          flash_notice_after_create
        end        
    end
    respond_to do |format|
      format.html{
        redirect_to(url_after_create)
        reset_session
      }
      format.js
    end
  end
  
  private

  def url_after_create
    :back
  end
  
  def url_after_destroy
    :back
  end
  
end