class FlagsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @forum = Forum.isprivate.first
    @reason = params[:flag][:reason]
    @user = current_user
    
    @flag = Flag.new(
          post_id: @topic.id,
          reason: @reason
          )

    if @flag.save
      @topics = @forum.topics.new(
      name: "Flagged for review: #{@topic.name}",
      private: true)

      @topics.user_id = @user.id

      if @topics.save
        @topics.posts.create(
          :body => "Reason for flagging: #{@flag.reason}\nTo view this post #{view_context.link_to 'Click Here', admin_topic_path(@topic)}",
          :user_id => @user.id,
          :kind => 'first'
          )

        @flag.update_attribute(:generated_topic_id, @topics.id)

        redirect_to topic_posts_path(@topic)
        flash[:success] = "This post has now been flagged."
      end
    end
  end

  def new
  end

  def index
  end
end
