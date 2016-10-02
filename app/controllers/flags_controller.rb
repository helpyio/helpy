class FlagsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @posts = @topic.posts

    @forum = Forum.isprivate.first

    @topics = @forum.topics.new(
    	name: "Flagged for review: #{@topic.name}",
    	private: true)

    puts "Topics: #{@topics.inspect}"

    @user = current_user

    puts "User: #{@user.inspect}"
    @topics.user_id = @user.id

    puts "Topics: #{@topics.inspect}"

    if @topics.save
      @flag = Flag.new(
          post_id: @topic.id,
          generated_topic_id: @topics.id,
          reason: params[:reason]
          )

      @topics.posts.create(
          :body => "Reason for flagging: #{@flag.reason}\nTo view this post #{view_context.link_to 'Click Here', admin_topic_path(@topic)}",
          :user_id => @user.id,
          :kind => 'first'
          )

      redirect_to topic_posts_path(@topic)
      flash[:success] = "This post has now been flagged."

    end
  end

  def new
  end
end
