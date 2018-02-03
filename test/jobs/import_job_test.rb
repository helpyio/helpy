require 'test_helper'

class ImportJobTest < ActiveSupport::TestCase
  def setup
    @admin = FactoryGirl.create(:admin)
  end

  # user import
  test "it should import all new records from valid csv" do
    setup_file(:user, 'user_import.csv')
    import = Import.create(model: 'user', status: "In Progress", submited_record_count: 45)
    ImportJob.perform_now(@files_detail, @admin, import)
    assert_equal Import.last.imported_ids.count, 45
  end

  test "it should save error_log for all unsaved records" do
    setup_file(:user, 'user_import.csv')
    2.times do
      import = Import.create(model: 'user', status: "In Progress", submited_record_count: 45)
      ImportJob.perform_now(@files_detail, @admin, import)
    end

    assert_equal Import.last.error_log.count, 45
  end

  test "it should update record if record is already present." do
    setup_file(:user, 'user_update.csv')
    user = User.find(8)
    import = Import.create(model: 'user', status: "In Progress", submited_record_count: 45)
    ImportJob.perform_now(@files_detail, @admin, import)
    updated_user = User.find(8)

    assert_not_equal updated_user.name, user.name
    assert_equal updated_user.name, 'megan updated name'
  end

  # Topic import
  test "it should import topic record from csv" do
    setup_file(:topic, 'topics_import.csv')
    import = Import.create(model: 'topic', status: "In Progress", submited_record_count: 1)
    ImportJob.perform_now(@files_detail, @admin, import)
    topic = Topic.last

    assert_equal topic.name, 'Overriding bandwidth is not working!'
  end

  # post import
  test "it should import post record from csv" do
    setup_file(:post, 'post_import.csv')
    import = Import.create(model: 'post', status: "In Progress", submited_record_count: 1)
    ImportJob.perform_now(@files_detail, @admin, import)
    post = Post.last

    assert_equal post.body, 'test of the body'
    assert_equal post.kind, 'first'
    assert_equal post.active, true
  end

  private

  def setup_file(key, file)
    filepath = Rails.root.join('test', 'fixtures', 'files', file).to_s
    @files_detail = {}
    @files_detail[key] = { path: filepath, name: file }
  end
end
