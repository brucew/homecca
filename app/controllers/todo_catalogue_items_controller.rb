class TodoCatalogueItemsController < ApplicationController
  before_filter :require_admin

  # GET /todo_catalogue_items
  # GET /todo_catalogue_items.xml
  def index
    @todo_catalogue_items = TodoCatalogueItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @todo_catalogue_items }
    end
  end

  # GET /todo_catalogue_items/1
  # GET /todo_catalogue_items/1.xml
  def show
    @todo_catalogue_item = TodoCatalogueItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @todo_catalogue_item }
    end
  end

  # GET /todo_catalogue_items/new
  # GET /todo_catalogue_items/new.xml
  def new
    @todo_catalogue_item = TodoCatalogueItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @todo_catalogue_item }
    end
  end

  # GET /todo_catalogue_items/1/edit
  def edit
    @todo_catalogue_item = TodoCatalogueItem.find(params[:id])
  end

  # POST /todo_catalogue_items
  # POST /todo_catalogue_items.xml
  def create
    @todo_catalogue_item = TodoCatalogueItem.new(params[:todo_catalogue_item])

    respond_to do |format|
      if @todo_catalogue_item.save
        format.html {
          flash[:notice] = 'TodoCatalogueItem was successfully created.'
          if params[:commit].match(/add photos$/)
            redirect_to new_todo_catalogue_item_pic_path(@todo_catalogue_item)
          else
            redirect_to @todo_catalogue_item
          end
        }
        format.xml { render :xml => @todo_catalogue_item, :status => :created, :location => @todo_catalogue_item }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @todo_catalogue_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /todo_catalogue_items/1
  # PUT /todo_catalogue_items/1.xml
  def update
    @todo_catalogue_item = TodoCatalogueItem.find(params[:id])

    respond_to do |format|
      if @todo_catalogue_item.update_attributes(params[:todo_catalogue_item])
        format.html {
          flash[:notice] = 'TodoCatalogueItem was successfully updated.'
          if params[:commit].match(/add photos$/)
            redirect_to new_todo_catalogue_item_pic_path(@todo_catalogue_item)
          else
            redirect_to @todo_catalogue_item
          end
        }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @todo_catalogue_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_catalogue_items/1
  # DELETE /todo_catalogue_items/1.xml
  def destroy
    @todo_catalogue_item = TodoCatalogueItem.find(params[:id])
    @todo_catalogue_item.destroy

    respond_to do |format|
      format.html { redirect_to(todo_catalogue_items_url) }
      format.xml { head :ok }
    end
  end

  def add_vid
    @f = params[:f]
    respond_to do |format|
        format.js
    end
  end

end
