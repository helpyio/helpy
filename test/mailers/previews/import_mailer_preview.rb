class ImportMailerPreview < ActionMailer::Preview

  def import_completion
    ImportMailer.notify_import_complition(User.find(3),'User','Your import was successful')
  end

end
