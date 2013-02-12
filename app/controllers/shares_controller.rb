class SharesController < ApplicationController

  # GET /offer_comments/new
  # GET /offer_comments/new.xml
  def new
    @request_id = params[:request_id]
    render :layout => false
  end

  # POST /offer_comments
  # POST /offer_comments.xml
  def create
    request = Request.find(params[:request_id])
    emails = params[:emails].split(%r{,\s*})
    unless request.nil? or emails.empty?
      emails.each do |email|
        Mailer.deliver_mimi_request_share(email, request)
      end
      flash[:notice] = 'You have successfully shared this skill request with your friends'
    end

    respond_to do |format|
      format.html { redirect_to new_share_path(:request_id => request.id) }
      format.js
    end
  end

end
