class PostsController < ApplicationController
    before_action :set_post, only: [:show, :update, :destroy]
  
    # GET /posts
    def index
      @posts = Post.all
      render json: @posts
    end
  
    # GET /posts/1
    def show
      render json: @post
    end
  
    # POST /posts
    def create
      @post = Post.new(post_params)
  
      if @post.save
        render json: @post, status: :created
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /posts/1
    def update
      if @post.update(post_params)
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /posts/1
    def destroy
      @post.destroy
    end
  
    # GET /posts/filter
    def filter
      @posts = Post.all
  
      if params[:author]
        @posts = @posts.where(author: params[:author])
      end
  
      if params[:date]
        @posts = @posts.where('published_at >= ?', params[:date].to_date.beginning_of_day)
                       .where('published_at <= ?', params[:date].to_date.end_of_day)
      end
  
      if params[:likes]
        @posts = @posts.order(likes: :desc)
      end
  
      if params[:comments]
        @posts = @posts.order(comments: :desc)
      end
  
      render json: @posts
    end
  
    # GET /posts/search
    def search
      query = params[:query]
      @posts = Post.where("title LIKE ? OR topic LIKE ? OR author LIKE ?",
                          "%#{query}%", "%#{query}%", "%#{query}%")
  
      render json: @posts
    end
  
    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def post_params
      params.require(:post).permit(:title, :topic, :featured_image, :text, :published_at, :author)
    end
  end
  