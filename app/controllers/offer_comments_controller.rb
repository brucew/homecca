class OfferCommentsController < ApplicationController

  # POST /offer_comments
  # POST /offer_comments.xml
  def create
    @offer = Offer.find(params[:offer_id])
    @offer_comment = @offer.offer_comments.build(params[:offer_comment])
    @offer_comment.commenter oh = current_user
    @offer_comment.save!
    Notify::offer_comment_create(@offer_comment)
    @offer.update_attribute(:read, false) if @offer.read? and current_user == @offer.offerer
    respond_to do |format|
      format.html { redirect_to @offer }
      format.js
    end
  end

end
