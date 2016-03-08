# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  name             :string
#  icon             :string
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  rank             :integer
#  front_page       :boolean          default(FALSE)
#  active           :boolean          default(TRUE)
#  permalink        :string
#  section          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class CategoriesController < ApplicationController
  before_action :get_tags

  before_action :authenticate_user!, :except => ['index', 'show']
  before_action :verify_admin, :only => ['new', 'edit', 'update', 'create', 'destroy']
  layout 'admin', :only => ['new', 'edit', 'update', 'create']

  # GET /categories
  # GET /categories.xml
  def index

    #if I18n.available_locales.count > 1
      @categories = Category.active.ordered.with_translations(I18n.locale)
    #else
    #  @categories = Category.active.alpha
    #end
    @page_title = I18n.t :knowledgebase, default: "Knowledgebase"
    @title_tag = "#{Settings.site_name}: " + @page_title
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
    if I18n.available_locales.count > 1
      @docs = @category.docs.ordered.active.with_translations(I18n.locale).page params[:page]
    else
      @docs = @category.docs.ordered.active.page params[:page]
    end
    @categories = Category.active.alpha.with_translations(I18n.locale)
    @related = Doc.in_category(@doc.category_id) if @doc

    @page_title = @category.name
    @title_tag = "#{Settings.site_name}: #{@page_title}"
    @meta_desc = @category.meta_description
    @keywords = @category.keywords

    add_breadcrumb t(:knowledgebase, default: "Knowledgebase"), categories_path
    add_breadcrumb @page_title, category_path(@category)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to(admin_knowledgebase_path)
    else
      render :knowledgebase
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    I18n.locale = params['lang']

    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to admin_knowledgebase_path
    else
      render :edit
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
    params.require(:category).permit(
    :name,
    :keywords,
    :title_tag,
    :icon,
    :meta_description,
    :front_page,
    :active,
    :section,
    :rank
  )
  end

end
