require 'test_helper'

class ImportJobTest < ActiveSupport::TestCase

	#user import
  test "it should import all new records from valid csv" do
  	admin = FactoryBot.create(:admin)
  	files_detail = {}
  	file = File.join(Rails.root, 'test', 'fixtures', 'files', 'user_import.csv')
    files_detail[:user] = {path: file, name: 'user_import.csv'}
    import = Import.create(model: 'user', status: "In Progress", submited_record_count: 45)
    ImportJob.perform_now(files_detail, admin, import)
		assert_equal Import.last.imported_ids.count, 45
  end

  test "it should save error_log for all unsaved records" do
  	admin = FactoryBot.create(:admin)
  	files_detail = {}
  	file = File.join(Rails.root, 'test', 'fixtures', 'files', 'user_import.csv')
    files_detail[:user] = {path: file, name: 'user_import.csv'}
    2.times do
      import = Import.create(model: 'user', status: "In Progress", submited_record_count: 45)
      ImportJob.perform_now(files_detail, admin, import)
    end

		assert_equal Import.last.error_log.count, 45
  end

  test "it should update record if record is already present." do
  	admin = FactoryBot.create(:admin)
  	user = User.find(8)

  	files_detail = {}
  	file = File.join(Rails.root, 'test', 'fixtures', 'files', 'user_update.csv')
    files_detail[:user] = {path: file, name: 'user_update.csv'}
    import = Import.create(model: 'user', status: "In Progress", submited_record_count: 45)
    ImportJob.perform_now(files_detail, admin, import)
    updated_user = User.find(8)

    assert_not_equal updated_user.name, user.name
		assert_equal updated_user.name, 'megan updated name'
  end

  #Topic import
  test "it should import topic record from csv" do
    admin = FactoryBot.create(:admin)

    files_detail = {}
    file = File.join(Rails.root, 'test', 'fixtures', 'files', 'topics_import.csv')
    files_detail[:topic] = {path: file, name: 'topics_import.csv'}
    import = Import.create(model: 'topic', status: "In Progress", submited_record_count: 1)
    ImportJob.perform_now(files_detail, admin, import)
    imported_topic = Topic.find(100)

    assert_equal imported_topic.name, 'Overriding bandwidth is not working!'

  end

  #post import
  test "it should import post record from csv" do
    admin = FactoryBot.create(:admin)

    files_detail = {}
    file = File.join(Rails.root, 'test', 'fixtures', 'files', 'post_import.csv')
    files_detail[:post] = {path: file, name: 'post_import.csv'}
    import = Import.create(model: 'post', status: "In Progress", submited_record_count: 1)
    ImportJob.perform_now(files_detail, admin, import)
    post = Post.find_by_body('test of the body')

    assert_not_nil post
    assert_equal post.kind, 'first'
    assert_equal post.active, true
  end
end
