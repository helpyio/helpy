class Admin::ForumsController < Admin::BaseController

  before_action :verify_agent
  respond_to :html, only: ['index','show','new','edit','create']
  respond_to :js, only: :destroy

  def index
    @forums = Forum.where(private: false).order('name ASC')
  end

  def new
    @forum = Forum.new
  end

  def edit
    @forum = Forum.find(params[:id])
  end

  def create
    @forum = Forum.new(forum_params)
    if @forum.save
      redirect_to admin_forums_path
    else
      render :new
    end
  end

  def update
    @forum = Forum.find(params[:id])
    if @forum.update(forum_params)
      redirect_to admin_forums_path
    else
      render :edit
    end
  end

  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
  end

  private

  def forum_params
    params.require(:forum).permit(
      :name,
      :description,
      :layout,
      :private,
      :allow_topic_voting,
      :allow_post_voting
    )
  end


end
