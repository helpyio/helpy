class Admin::ForumsController < Admin::BaseController

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

    respond_to do |format|
      if @forum.save
        flash[:notice] = 'Forum was successfully created.'
        format.html { redirect_to admin_forums_path }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @forum = Forum.find(params[:id])

    respond_to do |format|
      if @forum.update(forum_params)
        flash[:notice] = 'Forum was successfully updated.'
        format.html { redirect_to admin_forums_path }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to admin_forums_path }
      format.js
    end
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
