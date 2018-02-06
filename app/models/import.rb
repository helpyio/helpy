# == Schema Information
#
# Table name: imports
#
#  id                    :integer          not null, primary key
#  status                :string
#  notes                 :string
#  model                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  error_log             :text
#  imported_ids          :text
#  submited_record_count :integer
#  started_at            :datetime
#  completed_at          :datetime
#

class Import < ActiveRecord::Base
	serialize :error_log, Array
	serialize :imported_ids, Array
end
