class UsersController < ApplicationController
  before_action :signed_in?, except: [:new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash.now[:notice] = "Welcome!"
      sign_in @user
      redirect_to @user
    else
      flash[:errors] = @user.errors.full_messages.to_sentence
      redirect_to new_user_path
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    @last_post = @user.posts.last
  end

  def destroy
    current_user.destroy
    sign_out
    redirect_to new_user_path
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
