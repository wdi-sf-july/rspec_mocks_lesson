class SessionsController < ApplicationController

  before_action :find_user_by_email, only: [:create]
  
  def new
  end

  def create
    if @user && @user.authenticate(session_params[:password])
      sign_in @user
      redirect_to user_path @user
    else
      flash[:error] = "Invalid email or password"
      redirect_to login_path
    end
  end

  def destroy
    sign_out
    redirect_to login_path
  end
  private
    def session_params
      params.require(:session).permit(:email, :password)
    end

    def find_user_by_email
      @user = User.find_by_email(session_params[:email])
    end
end
