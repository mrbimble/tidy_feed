class Post
	attr_accessor :title, :link, :guid, :creator, :feed_id, :pubDate, :content

	def initialize(title, link, guid, creator, feed_id, pubDate, content)
		@title = title
		@link = link
		@guid = guid
		@creator = creator
		@feed_id = feed_id
		@pubDate = pubDate
		@content = content
	end

	def create_insert_string
		time = Time.new

		@title = "N/A" if @title.nil?
		@link = "N/A" if @link.nil?
		@creator = "N/A" if @creator.nil?
		@feed_id = 0 if @feed_id.nil?
		@pubDate = Time.now if @pubDate.nil?
		@content = "N/A" if @content.nil?

		"(\'" + @title + "\', \'" + @link + "\', \'" + @guid + "\', \'" + @creator + "\', " + @feed_id + ", \'" + @pubDate.to_s + "\', \'" + content + "\', \'" + time.strftime("%Y-%m-%d %H:%M:%S") + "\', \'" + time.strftime("%Y-%m-%d %H:%M:%S") + "\')"
	end

	def to_s
		@title + " - " + @link
	end
end