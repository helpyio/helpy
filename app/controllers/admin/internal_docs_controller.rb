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
      @user = User.new unless user_signed_in?
      add_breadcrumb t(:knowledgebase, default: "Knowledgebase"), admin_internal_categories_path
      add_breadcrumb @doc.category.name, admin_internal_category_path(@doc.category) if @doc.category.name
      add_breadcrumb @doc.title
    else
      redirect_to controller: 'errors', action: 'not_found'
    end
  end

end
