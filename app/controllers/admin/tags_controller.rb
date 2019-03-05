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
    tag_ids = ActsAsTaggableOn::Tagging.all.where(context: "tags", taggable_type: "Topic").includes(:tag).map{|tagging| tagging.tag.id }.uniq
    @tags = ActsAsTaggableOn::Tag.where("id IN (?)", tag_ids)
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
    tag = ActsAsTaggableOn::Tag.create(tag_params)
    if ActsAsTaggableOn::Tagging.create(tag_id: tag.id, taggable_type: 'Topic', context: "tags")
      redirect_to admin_tags_path
    else
      render new_admin_tag_path
    end
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.taggings.destroy_all if @tag.taggings.present?
    @tag.destroy
    redirect_to admin_tags_path
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
