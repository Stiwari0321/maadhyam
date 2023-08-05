class PostsController < ApplicationController
    before_action :set_post, only: [:show, :update, :destroy]
  
    # GET /posts
    def index
      @posts = Post.all.includes(:likes, :comments)
      render json: @posts, include: { likes: {}, comments: { except: [:post_id] } }
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

    def top_posts
      @top_posts = Post.order('likes_count DESC').limit(5)
      render json: @top_posts, include: { likes: {}, comments: { except: [:post_id] } }
    end

    def more_posts_by_author
      @post = Post.find(params[:id])
      @more_posts = @post.author.posts.where.not(id: @post.id).limit(5)
      render json: @more_posts, include: { likes: {}, comments: { except: [:post_id] } }
    end

    def recommended_posts
      @post = Post.find(params[:id])
      @recommended_posts = recommended_posts_for(@post)
      render json: @recommended_posts, include: { likes: {}, comments: { except: [:post_id] } }
    end
  
    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def post_params
      params.require(:post).permit(:title, :topic, :featured_image, :text, :published_at, :author)
    end

    
    def recommended_posts_for(post)
      # Get the list of topic ids for the current post
      current_post_topic_ids = post.topic_ids
  
      # Get other posts with at least one common topic with the current post
      @recommended_posts = Post.joins(:topics)
                               .where.not(id: post.id)
                               .where(topics: { id: current_post_topic_ids })
                               .distinct
                               .limit(5)
                               .includes(:likes, :comments)
                               .order('likes_count DESC')
  
      # If there are not enough posts with common topics, you can get additional posts
      # based on other criteria, e.g., recent posts, popular posts, etc.
      remaining_count = 5 - @recommended_posts.length
      if remaining_count.positive?
        other_posts = Post.where.not(id: post.id)
                          .where.not(id: @recommended_posts.map(&:id))
                          .limit(remaining_count)
                          .includes(:likes, :comments)
                          .order('likes_count DESC')
  
        @recommended_posts += other_posts
      end
  
      @recommended_posts
    end 
    

  end
  