class UsersController < ApplicationController
  helper_method :current_user
  before_action :send_back_to_the_cats, only: [:new, :create]


  def create
    @user = User.new(user_params)

    if @user.save
      login_user
    else

      flash.now[:errors] =  @user.errors.full_messages
      render :new
    end
  end

  def new

    @new_user = true
    render :new
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
