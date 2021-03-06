class PostsController < ApplicationController
  before_action :tags
  before_action :find_post, only: [:show, :edit, :update]
  before_action :admin?, except: [:index, :show, :tag]

  def index
    @posts = Post.last(6).reverse
    @title_post = Post.last
  end

  def show
    @posts = Post.where(tag: @post.tag).sort
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    if @post.update_attributes!(post_params)
      redirect_to root_path
    end
  end

  def tag
    @posts = Post.where(tag: params[:tag]).sort
    @title_post = @posts.last
  end

private

  def tags
    @tags = Post.tags
  end

  def post_params
    params.require(:post).permit(:title, :gist, :slug, :hero_image, :thumb_image, :tag, :body)
  end

  def find_post
    @post = Post.find_by_slug(params[:id])
  end

  def admin?
    if current_user.nil?
      redirect_to root_path
    else
      unless current_user.role == "Admin"
        redirect_to root_path
      end
    end
  end
end
