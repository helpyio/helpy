class ImportJob < ApplicationJob
  queue_as :import
  require 'roo'
  STATUS = {error: "Error", in_progress: "In Progress", completed: "Completed"}
  FORMAT_ERROR_MSG = "“The import CSV file was incorrectly formatted.”"
  SUCCESS_MSG = "Import completed"

  @@error_objs = []
  @@imported_ids = []
  @@submited_record_count = 0

  def perform(files_detail, user, import)
    files_detail.each do |klass, detail|
      @@error_objs = []
      @@imported_ids = []
      @@submited_record_count = 0
      import(detail[:path], detail[:name], klass.to_s.capitalize.constantize, user, import)
    end
  end

  def import(file_path, file_name, klass, user, import)
    started_at = Time.now
    spreadsheet = open_spreadsheet(file_path, file_name)
    header = spreadsheet.row(1)
    if true #header == klass.new.attributes.keys
      index = 1
      CSV.foreach(file_path, encoding:'iso-8859-1:utf-8') do |row|
        if index > 1
          row = Hash[[header, row].transpose]
          object_and_row = get_object_and_row(row, klass)
          if object_and_row[:row]["id"].present? && object_and_row[:object].present?
            send("#{klass.class_name.downcase}_import", object_and_row[:row].to_hash, index, object_and_row[:object])
          else
            send("#{klass.class_name.downcase}_import", object_and_row[:row].to_hash, index)
          end
        end
        index += 1
      end
      import.update_attributes(status: STATUS[:completed], notes: SUCCESS_MSG)
    else
      import.update_attributes(status: STATUS[:error], notes: FORMAT_ERROR_MSG)
    end
    import.update_attributes(error_log: @@error_objs, imported_ids: @@imported_ids, submited_record_count: @@submited_record_count, started_at: started_at, completed_at: Time.now)
    ImportMailer.notify_import_complition(user, klass.class_name.downcase, import.notes).deliver_later
    ActiveRecord::Base.connection.reset_pk_sequence!("#{klass.class_name.downcase}s")
  end

  def user_import(obj_hash, row_num, object=nil)
    @@submited_record_count += 1
    begin
      if object.present?
        object.attributes = obj_hash
      else
        object = User.new
        object.attributes = obj_hash
        object.password = User.create_password
        object.sign_in_count = 0
      end
      if object.save
        @@imported_ids << object.id
      else
        @@error_objs << obj_hash.merge!({error_message: object.errors.full_messages, row_number: row_num})
      end
    rescue
      @@error_objs << obj_hash.merge!({error_message: "error in saving.", row_number: row_num})
    end
  end

  def topic_import(obj_hash, row_num, object=nil)
    @@submited_record_count += 1
    obj_hash.reject!{|k| k=="posts_count" }

    if obj_hash["forum_id"].present? && obj_hash["user_id"].present?
      if Forum.find_by_id(obj_hash["forum_id"]).present? && User.find_by_id(obj_hash["user_id"]).present?
        begin
          if object.present?
            object.attributes = obj_hash
          else
            object = Topic.new
            object.attributes = obj_hash
          end
          if object.save
            @@imported_ids << object.id
          else
            @@error_objs << obj_hash.merge!({error_message: object.errors.full_messages, row_number: row_num})
          end
        rescue
          @@error_objs << obj_hash
        end
      end
    else
      @@error_objs << obj_hash
    end
  end

  def post_import(obj_hash, row_num, object=nil)
    @@submited_record_count += 1
    obj_hash.reject!{|k| k=="attachments" }
    if obj_hash["topic_id"].present? && obj_hash["user_id"].present?
      if Topic.find_by_id(obj_hash["topic_id"]).present? && User.find_by_id(obj_hash["user_id"]).present?
        begin
          if object.present?
            object.attributes = obj_hash
          else
            object = Post.new
            object.importing = true
            object.attributes = obj_hash
          end
          if object.save
            @@imported_ids << object.id
          else
            @@error_objs << obj_hash.merge!({error_message: object.errors.full_messages, row_number: row_num})
          end
        rescue
          @@error_objs << obj_hash
        end
      end
    else
      @@error_objs << obj_hash
    end
  end

  def forum_import(obj_hash, row_num, object=nil)
    @@submited_record_count += 1
    begin
      if object.present?
        object.attributes = obj_hash
      else
        object = Forum.new
        object.attributes = obj_hash
      end
      if object.save
        @@imported_ids << object.id
      else
        @@error_objs << obj_hash.merge!({error_message: object.errors.full_messages, row_number: row_num})
      end
    rescue
      @@error_objs << obj_hash
    end
  end

  def category_import(obj_hash, row_num, object=nil)
    @@submited_record_count += 1
    begin
      if object.present?
        object.attributes = obj_hash
      else
        object = Category.new
        object.attributes = obj_hash
      end
      if object.save
        @@imported_ids << object.id
      else
        @@error_objs << obj_hash.merge!({error_message: object.errors.full_messages, row_number: row_num})
      end
    rescue
      @@error_objs << obj_hash
    end
  end

  def doc_import(obj_hash, row_num, object=nil)
    @@submited_record_count += 1
    if obj_hash["user_id"].present? && obj_hash["category_id"].present?
      if User.find_by_id(obj_hash["user_id"]).present? && Category.find_by_id(obj_hash["category_id"]).present?
        begin
          if object.present?
            object.attributes = obj_hash
          else
            object = Doc.new
            object.attributes = obj_hash
          end
          if object.save
            @@imported_ids << object.id
          else
            @@error_objs << obj_hash.merge!({error_message: object.errors.full_messages, row_number: row_num})
          end
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

  def self.schedule_user_imoprt
    files_detail = {}
    file = File.join(Rails.root, 'user_update.csv')
    files_detail[:user] = {path: file, name: 'user_update.csv'}
    ImportJob.perform_later(files_detail, User.admins.first)
  end

  private

  def get_object_and_row(row, klass)
    object = nil
    object = klass.find_by_id(row["id"]) if row["id"].present?
    {object: object, row: row}
  end

  def topic_row(klass, row)
    user = User.find(row["user_id"])
    row["user_id"] = user.id if user
    row
  end

  def post_row(klass, row)
    # topic = Topic.find(row["topic_id"]) if row["topic_id"].present?
    # user = User.find(row["user_id"]) if row["user_id"].present?
    #
    # row["user_id"] = user.id if user
    # row["topic_id"] = topic.id if topic
    row
  end
end
