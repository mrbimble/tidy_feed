class StaticPagesController < ApplicationController

  def help
  end

  def home
  	if signed_in?
      puts current_user.stream
  		@posts = current_user.stream.paginate(page: params[:page])
  	else
  		@posts = Post.paginate(page: params[:page])
  	end
  end
  
end
