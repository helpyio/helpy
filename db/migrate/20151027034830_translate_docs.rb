class TranslateDocs < ActiveRecord::Migration
  def self.up
    Doc.create_translation_table!({
      :title => :string,
      :body => :text,
      :keywords => :string,
      :title_tag => :string,
      :meta_description => :string
    }, {
      :migrate_data => true
    })

    Category.create_translation_table!({
      :name => :string,
      :keywords => :string,
      :title_tag => :string,
      :meta_description => :string
    }, {
      :migrate_data => true
    })

  end

  def self.down
    Doc.drop_translation_table! :migrate_data => true
    Category.drop_translation_table! :migrate_data => true
  end
end
