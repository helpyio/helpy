class Admin::ImportsController < Admin::BaseController

  before_action :verify_admin
  before_action :available_file_details, only: [:restore]
  layout 'admin-settings'

  def restore
    if @files_detail.present?
      row_count = CSV.read(params[:file].path, headers: true, encoding:'iso-8859-1:utf-8').length - 1
      import = Import.create(model: params[:type].downcase, status: "In Progress", submited_record_count: row_count)
      ImportJob.perform_later(@files_detail, current_user, import)
      redirect_to admin_imports_path
    else
      flash[:error] = "Please select file to import"
      redirect_to admin_imports_path
    end
  end

  def index
    @imports = Import.all.order(created_at: :desc).page(params[:page])
  end

  def show
    @import = Import.find(params[:id])
    @error_log = Kaminari.paginate_array(@import.error_log).page(params[:page]).per(10)
  end

  private

  def available_file_details
    @files_detail = {}
    @files_detail[params[:type].downcase.to_sym] = {path: params[:file].path, name: params[:file].original_filename} if params[:file].present?
  end
end
