class ImportJob < ActiveJob::Base
  queue_as :default
  require 'roo'

  def perform(files_detail, klass)
    files_detail.each do |klass, detail|
      import(detail[:path], detail[:name], klass.to_s.capitalize.constantize)
    end
  end

  def import(file_path, file_name, klass)
    spreadsheet = open_spreadsheet(file_path, file_name)
    header = spreadsheet.row(1)
    if header == klass.new.attributes.keys
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        object = klass.find_by_id(row["id"]) if row["id"].present?
        if row["id"].present? and object.present?
          #Skipping TODO: note id of skipped record
        else
          send("#{klass.class_name.downcase}_import", row.to_hash)
        end
      end
    else
      #notes The import CSV file was incorrectly formatted.
    end
  end

  def user_import(obj_hash)
    object = User.new
    object.attributes = obj_hash
    object.password = User.create_password
    object.sign_in_count = 0
    object.save!
  end

  def topic_import(obj_hash)
    if obj_hash["forum_id"].present? and obj_hash["user_id"].present?
      if Forum.find_by_id(obj_hash["forum_id"]).present? and User.find_by_id(obj_hash["user_id"]).present?
        object = Topic.new
        object.attributes = obj_hash
        object.save!
      end
    end
  end

  def post_import(obj_hash)
    if obj_hash["topic_id"].present? and obj_hash["user_id"].present?
      if Topic.find_by_id(obj_hash["topic_id"]).present? and User.find_by_id(obj_hash["user_id"]).present?
        object = Post.new
        object.attributes = obj_hash
        object.save!
      end
    end
  end

  def forum_import(obj_hash)
    object = Forum.new
    object.attributes = obj_hash
    object.save!
  end

  def category_import(obj_hash)
    object = Category.new
    object.attributes = obj_hash
    object.save!
  end

  def doc_import(obj_hash)
    if obj_hash["user_id"].present? and obj_hash["category_id"].present?
      if User.find_by_id(obj_hash["user_id"]).present? and Category.find_by_id(obj_hash["category_id"]).present?
        object = Doc.new
        object.attributes = obj_hash
        object.save!
      end
    end
  end

  def open_spreadsheet(file_path, file_name)
    if File.extname(file_name) == ".csv"
      csv = Roo::Spreadsheet.open(file_path)
    else
      raise "Unknown file type: #{file_name}"
    end
  end

end
