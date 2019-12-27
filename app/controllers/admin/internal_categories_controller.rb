class Admin::InternalCategoriesController < Admin::BaseController

  def index
    @categories = Category.internally.without_system_resource.with_translations(I18n.locale).ordered
  end

  def show
    @category = Category.internally.without_system_resource.active.where(id: params[:id]).first
    if @category
      if I18n.available_locales.count > 1
        @docs = @category.docs.ordered.active.with_translations(I18n.locale).page params[:page]
      else
        @docs = @category.docs.ordered.active.page params[:page]
      end

      @page_title = @category.name

      generate_page_breadcumbs
    else
      redirect_to controller: '/errors', action: 'not_found'
    end
  end

  private

  def generate_page_breadcumbs
    add_breadcrumb t(:internal_content, default: "Internal Content"), admin_internal_categories_path
    add_breadcrumb @docs.category.name, category_path(@docs.first.category) if !@doc.nil? && @doc.first.category.name
  end
end
