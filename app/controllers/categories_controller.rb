class CategoriesController < ApplicationController
  before_filter :get_tags

  before_filter :authenticate_user!, :except => ['index', 'show']
  #before_filter :authenticate_master?, :except => 'index'
  add_breadcrumb I18n.t :root, :root_path

  # GET /categories
  # GET /categories.xml
  def index

    @categories = Category.alpha

    @page_title = t(:knowledgebase)
    @title_tag = "#{Settings.site_name}: Knowledgebase"
    @meta_desc = "Knowledgebase for #{Settings.site_name}"
    @keywords = "Knowledgebase, Knowledge base, support, articles, documentation, how-to, faq, frequently asked questions"
    add_breadcrumb @page_title, categories_path

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.active.where(id: params[:id]).first
    @docs = @category.docs.ordered.active.page params[:page]
    @categories = Category.alpha
    @related = Doc.in_category(@doc.category_id) if @doc

    @page_title = @category.name.titleize
    @title_tag = "#{Settings.site_name}: #{@page_title}"
    @meta_desc = @category.meta_description
    @keywords = @category.keywords

    add_breadcrumb t(:knowledgebase), categories_path
    add_breadcrumb @page_title, category_path(@category)

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
    render layout: 'admin'
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new

      @category.name = params[:category][:name]

      respond_to do |format|
        if @category.save
          format.html { render :action => "edit", layout: 'admin' }#{ redirect_to(admin_categories_path) }
          #format.js
        else
          format.html { render controller: 'admin', action: "knowledgebase" }
        end
      end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.where(id: params[:id]).first

    @category.name = params[:category][:name]
    @category.keywords = params[:category][:keywords]
    @category.title_tag = params[:category][:title_tag]
    @category.icon = params[:category][:icon]
    @category.meta_description = params[:category][:meta_description]
    @category.front_page = params[:category][:front_page]
    @category.active = params[:category][:active]
    @category.section = params[:category][:section]
    @category.rank = params[:category][:rank]

    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_knowledgebase_path }
        #format.js
      else
        format.html { render action: 'edit', layout: 'admin' }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(admin_knowledgebase_path) }
      format.js
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

  private

  def category_params
    params.require(:doc).permit(:title, :body, :keywords, :title_tag, :meta_description, :category_id, :rank, :active, :front_page)
  end


end
