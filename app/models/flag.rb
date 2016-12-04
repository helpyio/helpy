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

class Flag < ActiveRecord::Base
  belongs_to :post
end
