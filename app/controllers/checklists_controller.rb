class ChecklistsController < ApplicationController
  layout 'newt'
  skip_before_filter :authenticate, :only => [:index, :show]
  def index
    @on_checklist = "on_checklist"
    @todo_catalogue_items = TodoCatalogueItem.find(:all)
    if current_user
      @added_todo_catalogue_items = current_user.todo_items.active.map(&:todo_catalogue_item_id).compact
    else
      @added_todo_catalouge_items = nil
    end
    @todo_item = TodoItem.new
    session[:back_link] = "/checklists"
  end
  
  def show
    @todo_catalogue_item = TodoCatalogueItem.find(params[:id])
    #total times slider should move
    @total_items = @todo_catalogue_item.vids.count.to_i + (@todo_catalogue_item.pics.count.to_i > 0 ? @todo_catalogue_item.pics.count.to_i : 1)
    
    if current_user
      @added_todo_catalogue_items = current_user.todo_items.active.map(&:todo_catalogue_item_id).compact
    else
      @added_todo_catalouge_items = nil
    end
    @todo_item = TodoItem.new
    @back_link = session[:back_link] ? session[:back_link] : "/" 
  end
  
  def create
    @todo_catalogue_item = TodoCatalogueItem.find(params[:todo_catalogue_item_id])
    @todo_item = @todo_catalogue_item.todo_items.new(params[:todo_item])
    @todo_item.creator = current_user
    @todo_item.save
    @added_todo_catalogue_items = current_user.todo_items.active.map(&:todo_catalogue_item_id).compact
    @times = @added_todo_catalogue_items.count(@todo_catalogue_item.id)
    respond_to do |format|
      format.js
    end
  end
  
end
