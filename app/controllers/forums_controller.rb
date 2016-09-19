# == Schema Information
#
# Table name: forums
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :text
#  topics_count       :integer          default(0), not null
#  last_post_date     :datetime
#  last_post_id       :integer
#  private            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  allow_topic_voting :boolean          default(FALSE)
#  allow_post_voting  :boolean          default(FALSE)
#  layout             :string           default("table")
#

class ForumsController < ApplicationController

  # Make sure forums are enabled
  before_action :forums_enabled?, only: ['index','show']

  respond_to :html
  theme :theme_chosen

  def index
    @page_title = t(:community, default: "Community")
    @forums = Forum.where(private: false).order('name ASC')
    add_breadcrumb @page_title
  end

  def show
    redirect_to topics_path(:forum_id => params[:id])
  end

end
