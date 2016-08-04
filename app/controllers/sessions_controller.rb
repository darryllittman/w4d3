class SessionsController < ApplicationController
  before_action :send_back_to_the_cats, only: [:new, :create]

  def new
    @new_user = false
    render :new
  end

  def create
    if params.has_key?(:session)
      @user = User.find_by_credentials(session_params[:user_name], session_params[:password])
      if @user
        login_user
      end
    else
      flash[:errors] = ["User or password incorrect...you figure it out!"]
      render :new
    end
  end

  def destroy
    if current_user
      current_user.reset_session_token!
    end
      session[:session_token] = nil
      redirect_to new_session_url
  end


  private

  def session_params
    params.require(:session).permit(:user_name, :password)
  end
end
