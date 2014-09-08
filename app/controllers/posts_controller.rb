class PostsController < ApplicationController

  before_action :signed_in?

  def index
    begin
      if params[:user_id]
        @user = User.foo(params[:user_id])
        @posts = @user.posts
      else
        @user = current_user
        @posts = @user.posts
      end
    rescue
      redirect_to current_user
    end
  end

  def show
    begin
      if params[:user_id]
        @user = User.find_by_id(params[:user_id])
        @post = @user.posts.find_by_id(params[:id])
      else
        @user = current_user
        @post = @user.posts.find_by_id(params[:id])
      end
    rescue
      redirect_to current_user
    end
  end

  def new
    if params[:user_id]
      redirect_to current_user
    else
      @post = Post.new
    end
  end

  def create
    post = current_user.posts.new(post_params)
    if post.save
      redirect_to post
    else
      @post = post
      render :new
    end
  end

  def edit
    @post = current_user.find_by_id(params[:id])
    unless @post
      redirect_to current_user
    end
  end

  def update
    post = current_user.posts.find_by_id(params[:id])
    if post
      flash[:error] = post.errors.full_messages unless post.update(post_params)
    else
      flash[:error] = "Ooops!"
    end
    redirect_to post
  end

  private

    def post_params
      params.require(:post).permit(:title, :body)
    end
end
