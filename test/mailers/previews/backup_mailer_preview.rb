class BackupMailerPreview < ActionMailer::Preview

  def backup_completion
    BackupMailer.notify_backup_complition(User.find(3),'User')
  end

end
