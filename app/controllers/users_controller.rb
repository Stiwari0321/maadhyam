# app/controllers/users_controller.rb
class UsersController < ApplicationController
    before_action :authenticate_user!
  
    def profile
      render json: current_user
    end

    def my_posts
        @posts = current_user.posts
        render json: @posts, include: { likes: {}, comments: {} }
    end
    
    def show
        @user = User.find(params[:id])
        render json: @user, include: :posts
    end


  end
  