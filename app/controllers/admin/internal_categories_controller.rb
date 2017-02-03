class Admin::InternalCategoriesController < Admin::BaseController

  def index
    @categories = Category.is_internal.ordered
  end

  def show
    @category = Category.is_internal.viewable.active.where(id: params[:id]).first
    if @category
      if I18n.available_locales.count > 1
        @docs = @category.docs.ordered.active.with_translations(I18n.locale).page params[:page]
      else
        @docs = @category.docs.ordered.active.page params[:page]
      end

      @categories = Category.is_internal.viewable.active.ordered.with_translations(I18n.locale)
      @related = Doc.in_category(@doc.category_id) if @doc

      @page_title = @category.name
      add_breadcrumb t(:knowledgebase, default: "Knowledgebase"), admin_internal_categories_path
      add_breadcrumb @page_title, admin_internal_category_path(@category)
    else
      redirect_to controller: 'errors', action: 'not_found'
    end
  end

end
