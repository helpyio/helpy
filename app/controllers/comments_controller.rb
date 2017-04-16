class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :get_doc

  # This method handles the first comment and subsequent replies, storing them
  # as a Topic with Posts
  def create
    if !@doc.topic.present?
      @topic = Topic.create_comment_thread(@doc.id, current_user.id)
    else
      @topic = Topic.where(doc_id: @doc.id).first
    end
    @post = @topic.posts.new(comment_params)
    @post.user_id = current_user.id
    @post.screenshots = params[:post][:screenshots]

    if @post.save
      redirect_to doc_relative_path(params[:request][:origin], @doc)
    else
      render 'new'
    end
  end

  private

  def comment_params
    params.require(:post).permit(
      :body,
      :kind,
      :user_id,
      {attachments: []}
    )
  end

  def get_doc
    @doc = Doc.find(params[:doc_id])
  end

  def doc_relative_path(origin, doc)
    if origin == 'internal'
      admin_internal_category_internal_doc_path(doc.category.id, doc.id)
    else
      doc_path(doc)
    end
  end

end
