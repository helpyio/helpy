# index.rss.builder
xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{Settings.site_name} #{@forum.name} Feed"
    xml.description ""
    xml.link "#{forum_topics_url(@forum)}"

    for topic in @topics
      xml.item do
        xml.title '@' + topic.user.login + ': ' + topic.name
        xml.description topic.posts.first.body
        xml.pubDate topic.created_at.to_s(:rfc822)
        xml.link topic_posts_url(topic)
      end
    end
  end
end
