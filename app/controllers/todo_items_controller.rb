class TodoItemsController < ApplicationController
  layout 'newt'

  def index
    @myhome = "myhome"
    @o = params[:o]
    @q = params[:q] || {}
    search = @o.nil? ? @q.merge(:by_due_on => true) : @q.merge(@o => true)
    if params[:catalogue_item]
      @todo_items = current_user.todo_items.active.search( :todo_catalogue_item_id=>params[:catalogue_item] ).all
    else
      @todo_items = current_user.todo_items.active.search(search).all
    end
    session[:show_due_on] =  @q[:due_on_equals] ? @q[:due_on_equals] : ""
    @todo_item = TodoItem.new
    session[:back_link] = "/todo_items"
    #gflash :notice => "Welcome" # example gritter message call on action
    respond_to do |format|
      format.html
      format.js
    end
  end

  def history
    @myhome = "myhome"#to select current menu
    @o = params[:o]
    @q = params[:q] || {}
    search = @o.nil? ? @q.merge(:by_created_at => true) : @q.merge(@o => true)

    @todo_items = current_user.todo_items.done.search(search).all
    @timeline_feed = current_user.todo_items.done.sort_by{|t| t.done_on }.map{|y| y.done_on} unless @todo_items.empty?
    @timeline_years = @timeline_feed.map{|y| y.year}.uniq if @timeline_feed
    @todo_item = TodoItem.new
    flash[:back_link] = "/todo_items"
    #gflash :notice => "Welcome" # example gritter message call on action
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @todo_item = TodoItem.new(params[:todo_item])
    @todo_item.creator = current_user
    @q = ActiveSupport::JSON.decode(params[:q])
    respond_to do |format|
      if @todo_item.save
        @todo_list_items = current_user.todo_items.active.search(@q).all
        @calendar_todo_items = TodoItem.active.find_all_by_creator_id(current_user.id)
        format.js
      else
        format.json { render :json => "Error", :status => 500 }
      end
    end
  end

  def edit
    @todo_item = TodoItem.find(params[:id])

    respond_to do |format|
      format.js
    end
  end
  def history_edit
    @todo_item = TodoItem.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @todo_item = TodoItem.find(params[:id])
    respond_to do |format|
      if @todo_item.update_attributes(params[:todo_item])
        @calendar_todo_items = TodoItem.active.find_all_by_creator_id(current_user.id)
        format.js
      else
        format.js
      end
    end
  end

  def history_update
    @todo_item = TodoItem.find(params[:id])
    respond_to do |format|
      if @todo_item.update_attributes(params[:todo_item])
        @calendar_todo_items = TodoItem.active.find_all_by_creator_id(current_user.id)
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    @todo_item = TodoItem.find(params[:id])
    @todo_item.destroy
    @calendar_todo_items = TodoItem.active.find_all_by_creator_id(current_user.id)
    respond_to do |format|
      format.js
    end
  end

end
