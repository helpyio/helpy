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
#

class DocsController < ApplicationController

  respond_to :html

  def show
    @doc = Doc.where(id: params[:id]).active.first

    unless @doc.nil?
      @page_title = @doc.title
      @custom_title = @doc.title_tag.blank? ? @page_title : @doc.title_tag
      @topic = @doc.topic
      @newtopic = Topic.new
      @post = @topic.posts.new unless @topic.nil?
      @posts = @topic.posts.ispublic.active.includes(:user) unless @topic.nil?
      @forum = Forum.for_docs.first
      @user = User.new unless user_signed_in?
      add_breadcrumb t(:knowledgebase, default: "Knowledgebase"), categories_path
      add_breadcrumb @doc.category.name, category_path(@doc.category) if @doc.category.name
      add_breadcrumb @doc.title
    else
      redirect_to root_url
    end
  end

end
