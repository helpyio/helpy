class Admin::ImagesController < Admin::BaseController

  before_action :verify_editor

  def create
    @image = Image.new(image_params)
    @image.save
    respond_to do |format|
        format.json { render json: {image_id: @image.id, url: @image.file.url}.to_json }
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    respond_to do |format|
        format.json { render json: {}}
    end
  end

  private

  def image_params
    params.require(:image).permit(
      :name,
      :extension,
      :file
    )
  end

end
