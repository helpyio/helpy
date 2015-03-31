class CategoriesController < ApplicationController
  before_filter :get_tags

  before_filter :authenticate_user!, :except => ['index', 'show']
  #before_filter :authenticate_master?, :except => 'index'


  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.alpha

    @title_tag = "#{Settings.site_name} Support: Knowledgebase"
    @meta_desc = "Knowledgebase for #{Settings.site_name}"
    @keywords = "Knowledgebase, Knowledge base, support, articles, documentation, how-to, faq, frequently asked questions"

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

  #  id               :integer          not null, primary key
  #  name             :string
  #  keywords         :string
  #  title_tag        :string(70)
  #  meta_description :string(160)
  #  rank             :integer
  #  front_page       :boolean          default(FALSE)
  #  active           :boolean          default(TRUE)
  #  permalink        :string
  #  section          :string
  #  created_at       :datetime         not null
  #  updated_at       :datetime         not null

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.where(id: params[:id]).first

    @category.name = params[:category][:name]
    @category.keywords = params[:category][:keywords]
    @category.title_tag = params[:category][:title_tag]
    @category.meta_description = params[:category][:meta_description]
    @category.front_page = params[:category][:front_page]
    @category.active = params[:category][:active]
    @category.section = params[:category][:section]
    @category.rank = params[:category][:rank]

    respond_to do |format|
      if @category.save!
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(admin_categories_path) }

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

  private

  def category_params
    params.require(:doc).permit(:title, :body, :keywords, :title_tag, :meta_description, :category_id, :rank, :active, :front_page)
  end


end
