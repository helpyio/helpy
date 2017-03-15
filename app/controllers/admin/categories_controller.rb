class Admin::CategoriesController < Admin::BaseController

  respond_to :html, only: ['index','show','new','edit','create']
  respond_to :js, only: ['destroy']

  # Make the instance vars available for when the create action fails
  before_action :set_categories_and_non_featured, only: [:index, :create]
  before_action :verify_editor

  def index
  end

  def show
    @category = Category.where(id: params[:id]).first
    @docs = @category.docs.ordered
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to(admin_categories_path)
    else
      render :new
    end
  end

  def update
    I18n.locale = params['lang']
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
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
    :rank,
    :team_list,
    :visibility
  )
  end

  def set_categories_and_non_featured
    @public_categories = Category.publicly.featured.ordered
    @public_nonfeatured_categories = Category.publicly.unfeatured.alpha
    @internal_categories = Category.only_internally.ordered
  end


end
