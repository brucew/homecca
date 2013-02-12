class RequestsController < ApplicationController

  skip_before_filter :authenticate, :only => [:index, :show]
  sortable_attributes 'requests.created_at', :name, :distance

  # GET /requests
  # GET /requests.xml
  def index
    @job_type = params[:job_type].nil? ? Request::ANY_JOB_TYPE : params[:job_type]
    @near = params[:near] == '' ? nil : params[:near]
    @order = params[:order] == '' ? 'date' : params[:order]
    params[:commit] = nil

    if @near.nil?
      loc, @near, found = get_user_geolocation
    else
      loc = GeoKit::Geocoders::GoogleGeocoder.geocode(@near)
      found = loc.success
      @near = loc.full_address
    end

    sorted_by = case @order
                  when 'distance' then
                    'distance asc'
                  else
                    'requests.created_at desc'
                end

    if found
      if @job_type == Request::ANY_JOB_TYPE
        @requests = Request.
            open.
            sorted_by(sorted_by).
            near(loc).
            all(:include => :requester).
            paginate(:page => params[:page])
      else
#        skills = Utility::Skills.new(@job_type)
#        @job_type = skills.search_string
#        search_tags = skills.search_tags
#        unless search_tags.empty?
          @requests = Request.
              open(:include => :requester).
              tagged_with(@job_type, :any => true).
              sorted_by(sorted_by).
              near(loc).
              paginate(:page => params[:page])
#        else
#          @requests = []
#        end
      end

    else
      flash.now[:notice] = "Your location cannot be determined. Please enter it below."
      @near = ''
      @requests = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @requests }
    end
  end

  # GET /requests/1
  # GET /requests/1.xml
  def show
    @request = Request.find(params[:id])
    @fb = Utility::FacebookMetadata.new(:title => @request.name,
                                        :description => @request.description,
                                        :image_url => 'http://www.homecca.com/images/homecca_logo.png')
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @request }
    end
  end

  # GET /requests/new
  # GET /requests/new.xml
  def new
    @request = Request.new
    @request.location = current_user.location
    @request.paid = true
    @request.trade = current_user.trade if current_user.provider?

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @request }
    end
  end

  # GET /requests/1/edit
  def edit
    @request = Request.find(params[:id])
  end

# POST /requests
# POST /requests.xml
  def create
    @request = Request.new(params[:request])
    @request.requester = current_user

    respond_to do |format|
      if @request.save
        Notify::request_create(@request)
        flash[:success] = 'Your request was successfully created, and we have notified matching providers in your area
                           as well as those you invited. You will be notified by email about the incoming offers.'
        format.html { redirect_to(@request) }
        format.xml { render :xml => @request, :status => :created, :location => @request }
      else
        flash_error_count(@request, 'job')
        format.html { render :action => "new" }
        format.xml { render :xml => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

# PUT /requests/1
# PUT /requests/1.xml
  def update
    @request = Request.find(params[:id])

    respond_to do |format|
      if @request.update_attributes(params[:request])
        Notify::request_update(@request)
        flash[:success] = 'Your request was successfully updated, and the offer providers (if any) have been notified.'
        format.html { redirect_to(@request) }
        format.xml { head :ok }
      else
        flash_error_count(@request, 'job')
        format.html { render :action => "edit" }
        format.xml { render :xml => @request.errors, :status => :unprocessable_entity }
      end
    end
  end

# DELETE /requests/1
# DELETE /requests/1.xml
  def destroy
    @request = Request.find(params[:id])
    active_offers = @request.offers.active
    @request.destroy
    Notify::request_destroy(active_offers, @request)

    respond_to do |format|
      format.html { redirect_to(user_path(@request.requester)) }
      format.xml { head :ok }
    end
  end

  def close
    @request = Request.find(params[:id])
    @rating = Rating.new
  end

  def complete
    @request = Request.find(params[:id])
    @rating = @request.build_rating(params[:rating])
    @rating.rater = current_user

    respond_to do |format|
      if @rating.save
        @request.update_attribute(:state, :completed)
        Notify::request_complete(@request)
        flash[:success] = 'You have rated and closed this request.'
        format.html { redirect_to(@request) }
        format.xml { render :xml => @rating, :status => :created, :location => @request }
      else
        flash.now[:error] = "Please select a score to rate this worker's performance on this job."
        format.html { render :action => 'close' }
        format.xml { render :xml => @rating.errors, :status => :unprocessable_entity }
      end
    end
  end

end
