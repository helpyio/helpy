class Admin::InternalCategoriesController < Admin::BaseController

  def index
    @categories = Category.internally.ordered
  end

  def show
    @category = Category.internally.viewable.active.where(id: params[:id]).first
    if @category
      if I18n.available_locales.count > 1
        @docs = @category.docs.ordered.active.with_translations(I18n.locale).page params[:page]
      else
        @docs = @category.docs.ordered.active.page params[:page]
      end

      @categories = Category.internally.viewable.active.ordered.with_translations(I18n.locale)
      @related = Doc.in_category(@doc.category_id) if @doc

      @page_title = @category.name
    else
      redirect_to controller: 'errors', action: 'not_found'
    end
  end

end
