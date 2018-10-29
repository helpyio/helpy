class Admin::CategoriesController < Admin::BaseController

  respond_to :html, only: ['index','show','new','edit','create']
  respond_to :js, only: ['destroy']

  # Make the instance vars available for when the create action fails
  before_action :set_categories_and_non_featured#, only: [:index, :show, :create]
  before_action :verify_editor

  layout 'admin-content'

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
      flash[:notice] = t(:model_created, default: "%{object_name} was saved", object_name: @category.name)
      redirect_to(admin_categories_path)
    else
      render :new
    end
  end

  def update
    I18n.locale = params['lang']
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:notice] = t(:model_updated, default: "%{object_name} was updated", object_name: @category.name)
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = t(:model_destroyed, default: "%{object_name} was deleted", object_name: @category.name)
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

end
