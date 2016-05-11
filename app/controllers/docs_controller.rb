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

  #before_filter :get_tags
  #before_filter :set_docs, :only => 'show'
  #after_filter :view_causes_vote, :only => 'show'

  respond_to :html

  def show
    @doc = Doc.where(id: params[:id]).active.first

    unless @doc.nil?
      @page_title = @doc.title
      @custom_title = @doc.title_tag.blank? ? @page_title : @doc.title_tag
      @title_tag = "#{AppSettings['settings.site_name']}: #{@custom_title}"
      @topic = @doc.topic
      @newtopic = Topic.new
      @post = @topic.posts.new unless @topic.nil?
      @posts = @topic.posts.ispublic.active.includes(:user) unless @topic.nil?

      @forum = Forum.for_docs.first
      #@topic = Topic.new
      @user = User.new unless user_signed_in?
      add_breadcrumb t(:knowledgebase, default: "Knowledgebase"), categories_path
      add_breadcrumb @doc.category.name, category_path(@doc.category) if @doc.category.name
      add_breadcrumb @doc.title
    else
      redirect_to root_url
    end

  end

  def set_docs
    if params[:permalink]
      @doc = Doc.find_by_permalink(params[:permalink])
    else
      # category = Category.find_by_link(params[:link])
      @doc = Doc.find_by_category_id(params[:link])
    end
    @related = Doc.in_category(@doc.category_id)
  end

  def home
    render(:layout => 'discussion')
  end

  protected

  #def get_tags
  #  @tags = Doc.tag_counts
  #end

  def view_causes_vote
    if user_signed_in?
      @doc.votes.create unless current_user.admin?
    else
      @doc.votes.create
    end
  end

end
