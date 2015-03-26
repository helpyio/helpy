# index.rss.builder
xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{Settings.site_name} Support Thread"
    xml.description ""
    xml.link "#{topic_posts_url(@topic)}"

    for post in @posts
      xml.item do
        xml.title '@' + post.user.login + ': '
        xml.description post.body
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link topic_posts_url(@topic)
      end
    end
  end
end
