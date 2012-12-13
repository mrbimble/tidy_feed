class RelationshipsController < ApplicationController
	before_filter :signed_in_user
	respond_to :html, :js

	def create
		if (params[:user][:followed_feed_ids]).nil?
			puts "NIL!!!!!!!!!!!!!!!!!"
		end
		new_feeds = params[:user][:followed_feed_ids]
		old_feeds = current_user.followed_feed_ids

		#Remove all old feeds
		old_feeds.each do |old_feed|
			current_user.unfollow!(old_feed)
		end

		#Follow new feeds
		new_feeds.each do |new_feed|
			feed_obj = Feed.find(new_feed)
			current_user.follow!(feed_obj)
		end

		flash[:success] = "Feed list updated."
		redirect_to feed_list_user_path(current_user)
	end

end