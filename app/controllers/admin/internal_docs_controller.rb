class Admin::InternalDocsController < Admin::BaseController
  before_action :knowledgebase_enabled?, only: ['show']

  respond_to :html

  def show
    @doc = Doc.where(id: params[:id], category_id: Category.is_internal.viewable).active.first

    unless @doc.nil?
      @page_title = @doc.title
      @custom_title = @doc.title_tag.blank? ? @page_title : @doc.title_tag
      @topic = @doc.topic.present? ? @doc.topic : Topic.new
      @post = @doc.topic.present? ? @topic.posts.new : Post.new
      @posts = @topic.posts.ispublic.active.includes(:user) unless @topic.nil?
      @forum = Forum.for_docs.first
      @comment = @forum.topics.new
      
    else
      redirect_to controller: 'errors', action: 'not_found'
    end
  end

end
