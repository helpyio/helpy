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

  # before_action :authenticate_user!, :except => ['index', 'show']
  # before_action :verify_admin, :only => ['new', 'edit', 'update', 'create', 'destroy']
  # layout 'admin', :only => ['new', 'edit', 'update', 'create']

  def index

    #if I18n.available_locales.count > 1
      @categories = Category.active.ordered.with_translations(I18n.locale)
    #else
    #  @categories = Category.active.alpha
    #end
    @page_title = I18n.t :knowledgebase, default: "Knowledgebase"
    @title_tag = "#{AppSettings['settings.site_name']}: " + @page_title
    @meta_desc = "Knowledgebase for #{AppSettings['settings.site_name']}"
    @keywords = "Knowledgebase, Knowledge base, support, articles, documentation, how-to, faq, frequently asked questions"
    add_breadcrumb @page_title, categories_path

    respond_to do |format|
      format.html # index.html.erb
    end
  end

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
    @title_tag = "#{AppSettings['settings.site_name']}: #{@page_title}"
    @meta_desc = @category.meta_description
    @keywords = @category.keywords

    add_breadcrumb t(:knowledgebase, default: "Knowledgebase"), categories_path
    add_breadcrumb @page_title, category_path(@category)

    respond_to do |format|
      format.html
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
