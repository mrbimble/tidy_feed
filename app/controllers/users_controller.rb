class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :update_followed_feeds, :feed_list]
  before_filter :correct_user, only: [:edit, :update, :show, :update_followed_feeds, :feed_list]
  before_filter :admin_user, only: [:index, :destroy]

  def new
  	@user = User.new
  end

  def show
    #Update this so only the user can see their profile.
  	@user = User.find(params[:id])
  end

  def create
    if signed_in?
      redirect_to root_path
    else
    	@user = User.new(params[:user])

      #For phase 1 - just assign user to follow all feeds
      Feed.all.each do |feed|
        @user.follow!(feed)
      end
      
    	if @user.save
        sign_in @user
        flash[:success] = "Welcome to Tidy Feed!"
    		redirect_to @user
    	else
    		render 'new'
    	end
    end
  end
  
  def feed_list
    @user = User.find(params[:id])
    @feeds = @user.followed_feeds
  end

  def edit
    #@user will be defined by the before filter - correct_user
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def update
    #@user will be defined by the before filter - correct_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "The user has been destroyed."
    redirect_to users_path
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
