# == Schema Information
#
# Table name: docs
#
#  id               :integer          not null, primary key
#  title            :string
#  body             :text
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  category_id      :integer
#  user_id          :integer
#  active           :boolean          default(TRUE)
#  rank             :integer
#  permalink        :string
#  version          :integer
#  front_page       :boolean          default(FALSE)
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  topics_count     :integer          default(0)
#  allow_comments   :boolean          default(TRUE)
#  attachments      :string           default([]), is an Array
#

class DocsController < ApplicationController

  before_action :knowledgebase_enabled?, only: ['show']
  theme :theme_chosen

  respond_to :html

  def show
    @doc = Doc.where(id: params[:id], category_id: Category.viewable).active.first

    unless @doc.nil?
      @page_title = @doc.title
      @custom_title = @doc.title_tag.blank? ? @page_title : @doc.title_tag
      @topic = @doc.topic.present? ? @doc.topic : Topic.new
      @post = @doc.topic.present? ? @topic.posts.new : Post.new
      @posts = @topic.posts.ispublic.active.includes(:user) unless @topic.nil?
      @forum = Forum.for_docs.first
      @comment = @forum.topics.new
      @user = User.new unless user_signed_in?
      add_breadcrumb t(:knowledgebase, default: "Knowledgebase"), categories_path
      add_breadcrumb @doc.category.name, category_path(@doc.category) if @doc.category.name
      add_breadcrumb @doc.title
    else
      redirect_to controller: 'errors', action: 'not_found'
    end
  end

end
