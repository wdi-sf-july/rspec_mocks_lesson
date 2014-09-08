module SessionsHelper

  def signed_in?
    if current_user.nil?
       redirect_to login_path
    end
  end

  def sign_in(user)
    session["user_id"] = user.id
    current_user = user
  end

  def current_user
    @current_user ||= User.find_by_id(session["user_id"])
  end

  def current_user=(user)
    @current_user = user
  end

  def sign_out
    @current_user = session["user_id"] = nil
  end
end
