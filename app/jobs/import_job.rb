  class ImportJob < ActiveJob::Base
  queue_as :default
  require 'roo'
  STATUS = {error: "Error", in_progress: "In Progress", completed: "Completed"}
  FORMAT_ERROR_MSG = "“The import CSV file was incorrectly formatted.”"
  SUCCESS_MSG = "Import completed"

  @@error_objs = []

  def perform(files_detail, user)
    files_detail.each do |klass, detail|
      @@error_objs = []
      import(detail[:path], detail[:name], klass.to_s.capitalize.constantize, user)
    end
  end

  def import(file_path, file_name, klass, user)
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
      import = Import.create(model: klass.class_name.downcase, status: STATUS[:completed], notes: SUCCESS_MSG)
    else
      import = Import.create(model: klass.class_name.downcase, status: STATUS[:error], notes: FORMAT_ERROR_MSG)
    end
    import.update_attributes(error_log: @@error_objs.to_s)
    ImportMailer.notify_import_complition(user, klass.class_name.downcase, import.notes).deliver_later
  end

  def user_import(obj_hash)
    begin
      object = User.new
      object.attributes = obj_hash
      object.password = User.create_password
      object.sign_in_count = 0
      object.save!
    rescue
      @@error_objs << obj_hash
    end  
  end

  def topic_import(obj_hash)
    if obj_hash["forum_id"].present? and obj_hash["user_id"].present?
      if Forum.find_by_id(obj_hash["forum_id"]).present? and User.find_by_id(obj_hash["user_id"]).present?
        begin
          object = Topic.new
          object.attributes = obj_hash
          object.save!
        rescue
          @@error_objs << obj_hash
        end
      end
    else
      @@error_objs << obj_hash
    end
  end

  def post_import(obj_hash)
    if obj_hash["topic_id"].present? and obj_hash["user_id"].present?
      if Topic.find_by_id(obj_hash["topic_id"]).present? and User.find_by_id(obj_hash["user_id"]).present?
        begin
          object = Post.new
          object.attributes = obj_hash
          object.save!
        rescue
          @@error_objs << obj_hash
        end  
      end
    else
      @@error_objs << obj_hash
    end
  end

  def forum_import(obj_hash)
    begin
      object = Forum.new
      object.attributes = obj_hash
      object.save!
    rescue
      @@error_objs << obj_hash
    end
  end

  def category_import(obj_hash)
    begin
      object = Category.new
      object.attributes = obj_hash
      object.save!
    rescue
      @@error_objs << obj_hash
    end
  end

  def doc_import(obj_hash)
    if obj_hash["user_id"].present? and obj_hash["category_id"].present?
      if User.find_by_id(obj_hash["user_id"]).present? and Category.find_by_id(obj_hash["category_id"]).present?
        begin
          object = Doc.new
          object.attributes = obj_hash
          object.save!
        rescue
          @@error_objs << obj_hash
        end
      end
    else
      @@error_objs << obj_hash
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
