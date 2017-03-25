require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
    sign_in users(:user)
  end

  # # A user who is signed in should be able to add a new comment and attach a file
  test 'a signed in user should be able to add a new comment and attach a file' do

    assert_difference 'Topic.count', 1, 'A topic should have been created' do
      assert_difference 'Post.count', 1, 'A post should have been created' do
        post :create, { doc_id: 1, locale: :en,
          post: {
            body: "this is the body",
            kind: "first",
            attachments: Array.wrap(uploaded_file_object(Post, :attachments, file))
          },
          request: {
            origin: 'public'
          }
        }
      end
    end

    assert_equal "logo.png", Post.last.attachments.first.file.file.split("/").last
    assert_equal "Discussion on Article 1", Topic.last.name
  end

  # # A user who is signed in should be able to add a new comment
  test 'a signed in user should be able to reply to a comment' do

    assert_difference 'Topic.count', 1, 'A topic should have been created' do
      assert_difference 'Post.count', 1, 'A post should have been created' do
        post :create, { doc_id: 1, locale: :en,
          post: {
            body: "this is the body",
            kind: "first"
          },
          request: {
            origin: 'public'
          }          
        }
      end
    end

    assert_equal "Discussion on Article 1", Topic.last.name
  end

  # A user who is signed in should be able to reply to an existing comment and attach a file
  test 'a signed in user should be able to reply to a new comment and attach a file' do

    doc = Doc.create(title: "New Doc", category_id: 3, body: "Something here")
    topic = Topic.create_comment_thread(doc.id, 2)
    topic.posts.create(body: 'This is the first', kind: 'first', user_id: 2)

    assert_difference 'Topic.count', 0, 'A topic should NOT have been created' do
      assert_difference 'Post.count', 1, 'A post should have been created' do
        post :create, { doc_id: doc.id, locale: :en,
          post: {
            body: "this is the body",
            kind: "reply",
            attachments: Array.wrap(uploaded_file_object(Post, :attachments, file))
          },
          request: {
            origin: 'public'
          }
        }
      end
    end

    assert_equal 2, topic.posts.count
    assert_equal "logo.png", Post.last.attachments.first.file.file.split("/").last
  end

  # A user who is signed in should be able to reply to an existing comment
  test 'a signed in user should be able to reply to a new comment' do

    doc = Doc.create(title: "New Doc", category_id: 3, body: "Something here")
    topic = Topic.create_comment_thread(doc.id, 2)
    topic.posts.create(body: 'This is the first', kind: 'first', user_id: 2)

    assert_difference 'Topic.count', 0, 'A topic should NOT have been created' do
      assert_difference 'Post.count', 1, 'A post should have been created' do
        post :create, { doc_id: doc.id, locale: :en,
          post: {
            body: "this is the body",
            kind: "reply"
          },
          request: {
            origin: 'public'
          }
        }
      end
    end

    assert_equal 2, topic.posts.count
  end

end
