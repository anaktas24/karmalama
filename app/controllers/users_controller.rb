class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:profile]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'User updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: 'User deleted successfully.'
  end


  def profile
    @user = current_user || User.new
  end

  def update_profile
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path
    else
      render :profile
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone, :picture)
  end

end
