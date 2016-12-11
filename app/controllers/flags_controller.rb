# == Schema Information
#
# Table name: flags
#
#  id                 :integer          not null, primary key
#  post_id            :integer
#  generated_topic_id :integer
#  reason             :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class FlagsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @topic = Topic.find(@post.topic_id)
    @forum = Forum.isprivate.first
    @reason = params[:flag][:reason]
    @user = current_user
    
    @flag = Flag.new(
          post_id: @post.id,
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

        redirect_to posts_path(@post)
        flash[:success] = "This post has now been flagged."
      end
    end
  end

  def new
  end

  def index
  end
end
