class PicsController < ApplicationController
  include S3SwfUpload::ViewHelpers

  def new
    case
      when params[:request_id]
        obj           = Request.find(params[:request_id])
        @picable_type = obj.type
        @destination  = edit_request_path(obj)
      when params[:provider_id]
        obj           = Provider.find(params[:provider_id])
        @picable_type = 'User' # Won't work when set to 'Provider'. Why?
        @destination  = edit_provider_path(obj)
      when params[:article_id]
        obj           = Article.find(params[:article_id])
        @picable_type = 'Article'
        @destination  = edit_article_path(obj)
      when params[:todo_catalogue_item_id]
        obj           = TodoCatalogueItem.find(params[:todo_catalogue_item_id])
        @picable_type = 'TodoCatalogueItem'
        @destination  = edit_todo_catalogue_item_path(obj)
      else
    end

    @picable_id  = obj.id
    @queue_limit = obj.unused_pics_count
  end

  def create
    @pic = Pic.new(params[:pic])

    respond_to do |format|
      if @pic.save
        format.js {}
      else
        format.js { render :text => 'alert("Failure from Rails!");' }
      end
    end
  end

end
