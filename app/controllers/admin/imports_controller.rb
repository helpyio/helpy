class Admin::ImportsController < Admin::BaseController

  before_action :verify_admin

  before_action :available_file_details, only: [:restore]
  def restore
    ImportJob.perform_later(@files_detail, current_user.id) 
    redirect_to admin_imports_path
  end

  private
  def available_file_details
    @files_detail = {}
    @files_detail[:user] = {path: params[:user].path, name: params[:user].original_filename} if params[:user].present?
    @files_detail[:topic] = {path: params[:topic].path, name: params[:topic].original_filename} if params[:topic].present?
    @files_detail[:post] = {path: params[:post].path, name: params[:post].original_filename} if params[:post].present?
    @files_detail[:doc] = {path: params[:doc].path, name: params[:user].original_filename} if params[:doc].present?
    @files_detail[:category] = {path: params[:category].path, name: params[:user].original_filename} if params[:category].present?
    @files_detail[:forum] = {path: params[:forum].path, name: params[:forum].original_filename} if params[:forum].present?
  end
end
