class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def login_user
    @user.reset_session_token!
    session[:session_token] = @user.session_token
    redirect_to cats_url
  end

  def send_back_to_the_cats
    redirect_to cats_url if current_user
  end

  def current_user
    User.find_by(session_token: session[:session_token])
  end
end
