# app/controllers/follows_controller.rb
class FollowsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @follow = current_user.follows.build(follow_params)
  
      if @follow.save
        render json: @follow, status: :created
      else
        render json: @follow.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def follow_params
      params.require(:follow).permit(:following_id)
    end
  end
  