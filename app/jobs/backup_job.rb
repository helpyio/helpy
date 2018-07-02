class BackupJob < ApplicationJob
  queue_as :default

  def perform(params, user_id)
    params.select{|k| params[k] == "1"}.keys.each do |model_name|
      klass = Object.const_get model_name
      records = klass.all.order(:id)
      user = User.find(user_id)
      backup = Backup.new(csv: to_csv(records), user_id: user_id, csv_name: "#{model_name}_#{DateTime.now.to_i}.csv", model: model_name)
      if backup.save
        logger.info("Backup created successfully")
        BackupMailer.notify_backup_complition(user, model_name).deliver_later
      else
        logger.info("backup error: #{backup.errors}")
      end
    end
  end

  def to_csv(records, options = {})
    CSV.generate(options) do |csv|
      csv << records.column_names
      records.find_each do |record|
        csv << record.attributes.values_at(*records.column_names)
      end
    end
  end

end
