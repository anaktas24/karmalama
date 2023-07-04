require 'yaml'
class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:profile]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user || User.new
  end

  def update
    @user = current_user

    # Check if the password fields are blank
    if user_params[:password].blank? && user_params[:password_confirmation].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      puts @user.errors.full_messages
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
    @interests = @user.interests
    @education_level = @user.education_level
    @work_level = @user.work_level
    @skillset = @user.skillset
    @language_skills = @user.language_skills
  end

  def my_bookings
    @bookings = current_user.bookings
  end

  #Impact Page

  def update_level
    level = 1
    level_points_mapping = YAML.load_file(Rails.root.join('config', 'levels.yml'))
    level_points_mapping.each do |mapping|
      break if self.points < mapping['points_required']
      level = mapping['level']
    end
    update(level: level)
  end


  private

  def calculate_level
    # Logic to determine the user's level based on points
  end

  def calculate_picture
    # Logic to determine the user's picture based on level
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone, { interests: [], skillset: [], language_skills: [] },
      :education_level, :work_level, :about_me, :picture)
  end
end
