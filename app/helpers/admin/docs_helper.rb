module Admin::DocsHelper

  def categories_collection
    Category.with_translations(I18n.locale).order(name: :asc).map {|c| [ c.name, c.id ] }
  end

end
