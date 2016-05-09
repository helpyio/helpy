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

  def index
    @page_title = t(:community, default: "Community")

    @forums = Forum.where(private: false).order('name ASC')
    add_breadcrumb @page_title
    @title_tag = "#{AppSettings['settings.site_name']}: #{@page_title}"
    @meta_desc = "Community discussion for #{AppSettings['settings.site_name']}"
    @keywords = "support, articles, documentation, how-to, faq, frequently asked questions, forum, discussion"

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @forums.to_xml }
    end
  end

  def show
    redirect_to topics_path(:forum_id => params[:id])
  end

end
