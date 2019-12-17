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
#  visibility       :string           default("all")
#

class CategoriesController < ApplicationController

  before_action :knowledgebase_enabled?, only: ['index','show']

  respond_to :html
  theme :theme_chosen

  def index
    # @categories = Category.publicly.active.ordered.with_translations(I18n.locale).includes(docs: :tags )
    @categories = Category.publicly.roots.active.ordered.featured.all.with_translations(I18n.locale).includes(docs: :tags )

    @page_title = I18n.t :knowledgebase, default: "Knowledgebase"
    add_breadcrumb @page_title, categories_path
  end

  def show
    @category = Category.publicly.active.where(id: params[:id]).first
    if @category
      if I18n.available_locales.count > 1
        @docs = @category.docs.ordered.active.with_translations(I18n.locale).page(params[:page]).includes(tags: :taggings)
      else
        @docs = @category.docs.ordered.active.page(params[:page]).includes(:tags)
      end
      @categories = Category.publicly.roots.active.ordered.with_translations(I18n.locale)
      @related = Doc.in_category(@doc.category_id) if @doc

      @page_title = @category.name

      add_breadcrumb t(:knowledgebase, default: "Knowledgebase"), categories_path
      @category.path.each do |cat|
        add_breadcrumb cat.name, category_path(cat)
      end
    else
      redirect_to controller: 'errors', action: 'not_found'
    end
  end
end
