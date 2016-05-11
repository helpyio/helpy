class Admin::CategoriesController < Admin::BaseController

  respond_to :html, only: ['index','show','new','edit','create']
  respond_to :js, only: ['destroy']

  def index
    @categories = Category.featured.ordered
    @nonfeatured = Category.where(front_page: false).alpha
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
      render :index
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
    :rank
  )
  end


end
