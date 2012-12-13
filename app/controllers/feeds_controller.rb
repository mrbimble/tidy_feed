class FeedsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user
	before_filter :admin_user

	def index
		@feeds = Feed.all
	end

	def create
		@feed = Feed.new(params[:feed])
		if @feed.save
			flash[:success] = "Feed successfully created."
			redirect_to feeds_path
		else
			render 'new'
		end
	end

	def destroy
		Feed.find(params[:id]).destroy
    	flash[:success] = "The feed has been destroyed."
    	redirect_to feeds_path
	end

	def update
		@feed = Feed.find(params[:id])
		if @feed.update_attributes(params[:feed])
			flash[:success] = "Feed successfully updated."
			redirect_to feeds_path
		else
			render 'edit'
		end
	end

	def edit
		@feed = Feed.find(params[:id])
	end

	def new
		@feed = Feed.new
	end

	def show
		@feed = Feed.find(params[:id])
	end

	private

		def signed_in_user
		  unless signed_in?
		    #store_location
		    #redirect_to signin_path, notice: "Please sign in"
		    redirect_to(root_path)
		  end
		end

		def correct_user
		  @user = User.find_by_remember_token(cookies[:remember_token])
		  redirect_to root_path unless current_user?(@user)
		end

		def admin_user
		  redirect_to(root_path) unless current_user.admin?
		end
end