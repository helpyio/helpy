# == Schema Information
#
# Table name: backups
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  csv        :text
#  model      :string
#  csv_name   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Backup < ActiveRecord::Base
	belongs_to :user
end
