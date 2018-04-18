# Preview all emails at http://localhost:3000/rails/mailers/post_mailer
class PostMailerPreview < ActionMailer::Preview

  def new_post
    PostMailer.new_post(1)
  end
  
end
