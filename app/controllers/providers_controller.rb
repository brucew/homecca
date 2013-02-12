class ProvidersController < UsersController
  skip_before_filter :authenticate, :only => [:index, :new, :create]

  sortable_attributes :created_at, :average_rating, :first_name, :business_name, :distance

  def show
    @provider = Provider.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @provider }
    end
  end

  def new
    @provider = Provider.new
    @provider.paid = true
    @provider.trade = true
    @provider.volunteer = true
  end

  def edit
    unless params[:id].to_i == current_user.id or current_user.admin?
      redirect_to edit_provider_path(current_user) and return
    end

    @provider = User.find(params[:id])

    unless @provider.provider?
      @provider = @provider.becomes(Provider)
      flash.now[:notice] = 'To make offers on jobs, you must first create a worker profile.'
    end

  end

  def create
    @provider = Provider.new params[:provider]
    @provider.skills = params_to_skills

    if @provider.save
      sign_in(@provider)
      flash[:success] = 'Welcome to Skillz! Here are some requests that match your skills.'
      redirect_to(requests_path(:job_type => @provider.skills, :near => @provider.location))
    else
      flash_error_count(@provider, 'profile')
      render :template => 'providers/new'
    end
  end

  def update
    if current_user.admin?
      @provider = Provider.find(params[:id])
    else
      @provider = current_user
    end

    unless @provider.provider?
      @provider = @provider.becomes(Provider)
      @provider.set_type
      new_provider = true
    else
      new_provider = false
    end

    @provider.skills = params[:provider][:skills]

    respond_to do |format|
      if @provider.update_attributes(params[:provider])
        flash[:success] = 'Your profile was successfully updated.'
        format.html {
          if new_provider
            flash[:success] = 'Your profile was successfully updated. Here are some requests that match your skills.'
            redirect_to(requests_path(:job_type => @provider.skills, :near => @provider.location))
          else
            redirect_to(provider_path(@provider))
          end
        }
        format.xml { head :ok }
      else
        flash_error_count(@provider, 'profile')
        format.html { render :action => 'edit' }
        format.xml { render :xml => @provider.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def params_to_skills
    skills = []
    Request::JOB_TYPES.each do |job_type|
      if params[job_type] == "on"
        skills << job_type
      end
    end
    return skills
  end
end
