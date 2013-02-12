class UsersController < BlueLightSpecial::UsersController

  def new
    @user = ::User.new(params[:user])
    session[:return_to] = params[:return_to]
    loc = session[:geo_location]
    unless loc.nil?
      @user.location = loc.full_address
    end

    render :template => 'users/new'
  end

  def create
    respond_to do |format|
      @user = ::User.new params[:user]
      #if !params[:user][:first_name] && !params[:user][:last_name]
      #  @user.first_name = 'noname'
      #  @user.last_name = 'noname'
      #end
      @user.facebook_uid = session[:user_facebook_uid]
      if @user.save
        session[:user_facebook_uid] = nil
        flash[:notice] = 'You have successfully signed up.'
        format.html { redirect_back_or(url_after_create) }
        format.js
      else
        format.html { render :template => 'users/new' }
        format.js
      end
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = 'Your profile was successfully updated.'
        format.html { redirect_to(settings_path) }
        format.xml { head :ok }
      else
        format.html {
          flash[:failure] = 'Error while updating profile'
          redirect_to(settings_path)
        }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def wizard_update
    if params[:location]
      @user = User.find(current_user.id)
      @user.location=params[:location]
      @user.save
    end
    if params[:add_defaults]

    end
    respond_to do |format|
      #  format.html
      format.js
    end
  end

end