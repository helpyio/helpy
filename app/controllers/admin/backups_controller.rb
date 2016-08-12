class Admin::BackupsController < Admin::BaseController

  before_action :verify_admin
  
  def index
    @files = current_user.backups.page params[:page]
  end

  def export
    BackupJob.perform_later(params[:model_name], current_user.id)
    redirect_to admin_backups_path
  end

  def download
    file = Backup.find params[:file_id]
    respond_to do |format|
      format.csv { send_data file.csv, :filename => file.csv_name }
    end
  end

end
