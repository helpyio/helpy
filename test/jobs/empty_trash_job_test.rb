require 'test_helper'

class EmptyTrashJobTest < ActiveJob::TestCase
  test 'it should delete all tickets in the trash' do
    Topic.update_all(current_status: 'deleting')
    assert_enqueued_jobs Topic.all.count do
      EmptyTrashJob.perform_now
    end
  end
end
