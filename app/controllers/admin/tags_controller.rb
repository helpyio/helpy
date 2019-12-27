# == Schema Information
#
# Table name: tags
#
#  id                     :integer          not null, primary key
#  name                   :string#

class Admin::TagsController < Admin::BaseController

  before_action :verify_admin

  layout 'admin-settings'

  def index
    @tag = ActsAsTaggableOn::Tag.new
    tag_ids = ActsAsTaggableOn::Tagging.all.where(context: "tags", taggable_type: "Topic").includes(:tag).map{|tagging| tagging.tag.id }.uniq
    @tags = ActsAsTaggableOn::Tag.where("id IN (?)", tag_ids).order(:name).page params[:page]
  end

  def new
    @tag = ActsAsTaggableOn::Tag.new
  end

  def edit
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def update
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    if @tag.update_attributes(tag_params)
      redirect_to admin_tags_path
    else
      render :edit
    end
  end

  def create
    @tag = ActsAsTaggableOn::Tag.new(tag_params)
    if @tag.save && ActsAsTaggableOn::Tagging.create(tag_id: @tag.id, taggable_type: 'Topic', context: "tags")
      flash[:notice] = "Tag Saved"
      respond_to do |format|
        format.html {
          redirect_to admin_tags_path
        }
        format.js {}
      end
    else
      respond_to do |format|
        format.html {
          render :new
        }
        format.js {
        }
      end      
    end
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.taggings.destroy_all if @tag.taggings.present?
    @tag.destroy
    flash[:notice] = "Tag has been deleted"
    respond_to do |format|
      format.html {
        redirect_to admin_tags_path
      }
      format.js {}
    end
  end

  private

  def tag_params
    params.require(:acts_as_taggable_on_tag).permit(
      :name,
      :description,
      :color
    )
  end
end
