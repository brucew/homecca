class RatingsController < ApplicationController
  # POST /ratings
  # POST /ratings.xml
  def create
    @request = Request.find(params[:request_id])
    @rating = @request.build_rating(params[:rating])
    @rating.rater = current_user

    respond_to do |format|
      if @rating.save
        flash[:success] = 'You have rated and closed this job.'
        format.html { redirect_to(@request) }
        format.xml { render :xml => @rating, :status => :created, :location => @rating }
      else
        format.html { render :action => 'new' }
        format.xml { render :xml => @rating.errors, :status => :unprocessable_entity }
      end
    end
  end
end