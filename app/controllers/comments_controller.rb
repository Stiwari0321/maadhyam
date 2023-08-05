# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @comment = current_user.comments.build(comment_params)
  
      if @comment.save
        render json: @comment, status: :created
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:post_id, :text)
    end
  end
  