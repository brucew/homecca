class OffersController < ApplicationController

  # GET /offers/1
  # GET /offers/1.xml
  def show
    @offer = Offer.find(params[:id])
    if current_user == @offer.request.requester
      @offer.update_attribute(:read, true)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @offer }
    end
  end

  # GET /offers/new
  # GET /offers/new.xml
  def new
    @request = Request.find(params[:request_id])
    existing_offer = @request.offers.by(current_user).first
    respond_to do |format|
      if existing_offer.nil?
        @offer = @request.offers.build
        format.html # new.html.erb
        format.xml { render :xml => @offer }
      else
        flash[:notice] = 'You have already submitted or removed this offer. By editing it now, it will become active again. The request owner will be notified of your revisions.'
        format.html { redirect_to edit_offer_path(existing_offer) }
        format.xml { render :xml => @request }
      end
    end
  end

  # GET /offers/1/edit
  def edit
    @offer = Offer.find(params[:id])
  end

  # POST /offers
  # POST /offers.xml
  def create
    @request = Request.find(params[:request_id])
    @offer = @request.offers.build(params[:offer])
    @offer.offerer = current_user

    respond_to do |format|
      if @offer.save
        flash[:success] = 'Your offer was successfully created, and the request owner has been notified.'
        Notify::offer_create(@offer)
        format.html { redirect_to(@offer) }
        format.xml { render :xml => @offer, :status => :created, :location => @offer }
      else
        flash_error_count(@offer)
        format.html { render :action => "new" }
        format.xml { render :xml => @offer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /offers/1
  # PUT /offers/1.xml
  def update
    @offer = Offer.find(params[:id])
    notify_requester = @offer.read?

    respond_to do |format|
      if @offer.editable? # sanity/hacking check
        if @offer.update_attributes(params[:offer])
          Notify::offer_update(@offer) if notify_requester
          flash[:success] = 'Your offer was successfully updated, and the request owner has been notified.'
          format.html { redirect_to(@offer) }
          format.xml { head :ok }
        else
          flash_error_count(@offer)
          format.html { render :action => "edit" }
          format.xml { render :xml => @offer.errors, :status => :unprocessable_entity }
        end
      else
        flash[:error] = 'This offer cannot be edited.'
        format.html { redirect_to(@offer) }
        format.xml { head :error }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.xml
  def destroy
    @offer = Offer.find(params[:id])
    @offer.destroy
    Notify::offer_destroy(@offer)

    respond_to do |format|
      format.html { redirect_to(request_path(@offer.request)) }
      format.xml { head :ok }
    end
  end

  def accept
    @offer = Offer.find(params[:id])
    if @offer
      @request = @offer.request
      @request.accepted_offer = @offer
      @request.save!
      Notify::offer_accept(@offer)
      flash[:notice] = 'Please contact the provider via offer conversation or email (that was sent to you) to discuss the service delivery.'
      redirect_to(provider_path(@request.provider))
    end
  end

  def reject
    @offer = Offer.find(params[:id])
    if @offer
      @offer.update_attribute(:state, :rejected)
      Notify::offer_reject(@offer, params[:reason])
      flash[:success] = 'Offer has been rejected.'
      redirect_to(request_path(@offer.request))
    end
  end

end
