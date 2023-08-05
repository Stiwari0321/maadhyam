# app/controllers/likes_controller.rb
class LikesController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @like = current_user.likes.build(like_params)
  
      if @like.save
        render json: @like, status: :created
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def like_params
      params.require(:like).permit(:post_id)
    end
  end
  