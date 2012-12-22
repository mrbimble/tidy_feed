require 'feedzirra'
require 'pg'
require 'base64'
require './Post.rb'
require 'ap'

#Master Array to hold Post objects
postList = []

#Open Connection
db = PGconn.new('ec2-54-243-230-119.compute-1.amazonaws.com', 5432, '', '', 'ddnjc0k1ddko8j', 'bvuzprcznkjvxd', 'OvS2zIXvi5h5GSAs-EGf69o9_S')

#Query
begin

	results = db.exec("SELECT * FROM feeds")
	puts "Number of feeds #{results.num_tuples}"

	results.each do |row|

		db_feed_id = row['id']
		
		#Open and parse feed
		feed = Feedzirra::Feed.fetch_and_parse(row['url'])

		puts "Feed: #{feed.title}"
		puts "URL: #{feed.url}"
		puts "Feed URL: #{feed.feed_url}"
		puts "Feed ID: #{db_feed_id}"
		entry = feed.entries.first
		feed.entries.each do |entry|
			encTitle = Base64.encode64(entry.title)
			encDesc = Base64.encode64(entry.summary)
			encAuthor = Base64.encode64(entry.author)
			
			myPost = Post.new(encTitle, entry.url, "N/A", encAuthor, db_feed_id, entry.published, encDesc)

			postList << myPost
		end
	end

ensure
	db.close unless db.nil?
end

############################################

#Array to hold only the new posts
new_post_list = []

#Check if posts already exist in database
db = PGconn.new('ec2-54-243-230-119.compute-1.amazonaws.com', 5432, '', '', 'ddnjc0k1ddko8j', 'bvuzprcznkjvxd', 'OvS2zIXvi5h5GSAs-EGf69o9_S')

postList.each do |post|

	query_string = "SELECT id, title FROM posts WHERE link = '#{post.link}'"
	db_post = db.exec(query_string)

	if db_post.ntuples.zero?
		new_post_list << post
	end
end

puts "New posts found: #{new_post_list.size}"

#############################################
if new_post_list.size > 0
	#Update database
	db = PGconn.new('ec2-54-243-230-119.compute-1.amazonaws.com', 5432, '', '', 'ddnjc0k1ddko8j', 'bvuzprcznkjvxd', 'OvS2zIXvi5h5GSAs-EGf69o9_S')
	#Begin Insert
	begin
		query_string = "INSERT INTO posts (title, link, guid, creator, feed_id, pubDate, content, created_at, updated_at) VALUES "
		count = 0

		#Build string of insert values
		new_post_list.each do |post|
			if count.zero?
				query_string = query_string + post.create_insert_string
			else
				query_string = query_string + ", " + post.create_insert_string
			end
			count = count + 1
		end
		
		db.exec(query_string)

		puts "Number of rows inserted: #{db.ntuples}"
	ensure
		db.close
	end
else
	puts "No new posts to submit to the database."
end


