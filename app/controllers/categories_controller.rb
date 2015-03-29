class CategoriesController < ApplicationController
  before_filter :get_tags

  before_filter :authenticate_user!, :except => ['index', 'show']
  #before_filter :authenticate_master?, :except => 'index'


  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.alpha

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories
  # GET /categories.xml
  def admin
    @categories = Category.alpha

    respond_to do |format|
      format.html { render :action => "admin", :layout => 'admin' }
    end
  end


  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.active.where(id: params[:id]).first
    @docs = @category.docs.ordered.active.page params[:page]
    @categories = Category.alpha
    @related = Doc.in_category(@doc.category_id) if @doc

    @title_tag = @category.title_tag
    @meta_desc = @category.meta_description
    @keywords = @category.keywords


    respond_to do |format|
      format.html
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html #{ render :layout => 'admin'}

    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.where(id: params[:id]).first
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:id])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(admin_help_path) }

      else
        format.html { render :action => "new" }

      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(admin_help_path) }

      else
        format.html { render :action => "edit" }

      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(admin_help_url) }
    end
  end

  def print
    @categories = Category.alpha.find(:all)
    render :layout => 'help'
  end


  protected

  def get_tags
    @tags = Doc.tag_counts
  end
end
