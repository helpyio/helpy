class Admin::InternalDocsController < Admin::BaseController
  before_action :knowledgebase_enabled?, only: ['show']
  before_action :doc_available_to_view?, only: ['show']

  respond_to :html

  def show
    define_topic_for_doc
    define_forum_for_docs
    generate_page_breadcumbs
  end

  private

  def doc_available_to_view?
    @doc = Doc.find_by(id: params[:id], active: true)
    redirect_to controller: '/errors', action: 'not_found' if @doc.nil? || !@doc.category.internally_viewable?
  end

  def generate_page_breadcumbs
    add_breadcrumb t(:internal_content, default: "Internal Content"), admin_internal_categories_path
    add_breadcrumb @doc.category.name, admin_internal_category_path(@doc.category) if @doc.category.name
    add_breadcrumb @doc.title
    @page_title = @doc.title
  end

  def define_forum_for_docs
    @forum = Forum.for_docs.first
    @comment = @forum.topics.new
  end

  def define_topic_for_doc
    if @doc.topic.present?
      @topic  = @doc.topic
      @post   = @topic.posts.new
      @posts  = @topic.posts.ispublic.active.includes(:user) unless @topic.nil?
    else
      @topic  = Topic.new
      @post   = Post.new
    end
  end

end
