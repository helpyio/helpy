class Admin::BackupsController < Admin::BaseController

  before_action :verify_admin
  layout 'admin-settings'

  def index
    @files = current_user.backups.order("created_at desc").page params[:page]
  end

  def export
    BackupJob.perform_later(params, current_user.id)
    redirect_to admin_backups_path
  end

  def download
    file = Backup.find params[:file_id]
    respond_to do |format|
      format.csv {
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=#{file.csv_name}"
        send_data file.csv, :filename => file.csv_name
      }
    end
  end

  def destroy
    file = Backup.find(params[:id])

    file.destroy
    redirect_to admin_backups_path
  end

end
