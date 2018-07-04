class DeleteUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    return if user.is_admin?
    return if user.id == 2 #prevent the system user from being destroyed

    topic_posts = Post.where(topic_id: Topic.where(user_id: user.id))

    # move any authored docs to system user
    Doc.where(user_id: user.id).update_all(user_id: 2)

    # unassign from any topics assigned to
    user.unassign_all

    # Remove all posts in threads created by destroyed user
    topic_posts.destroy_all

    # Remove PII from any backups or import errors

    user.destroy
  end
end
