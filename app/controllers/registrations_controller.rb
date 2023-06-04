# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def personal_info
    @user = User.new
  end

  def create_personal_info
    @user = User.new(personal_info_params)
    if @user.valid?
      session[:user] = @user.attributes
      redirect_to photo_registration_path
    else
      render 'personal_info'
    end
  end

  def photo
    @user = User.new
  end

  def create_photo
    @user = User.new(photo_params)
    if @user.valid?
      session[:user].merge!(@user.attributes)
      redirect_to account_details_registration_path
    else
      render 'photo'
    end
  end

  def account_details
    @user = User.new
  end

  def create_account_details
    @user = User.new(account_details_params)
    if @user.valid?
      session[:user].merge!(@user.attributes)
      # Create the user and perform any additional steps
      # e.g., saving the user to the database, sending notifications, etc.
      # You can access the user data in the session using `session[:user]`
      # Clear the session after registration is complete
      session[:user] = nil
      redirect_to root_path, notice: 'Registration completed successfully!'
    else
      render 'account_details'
    end
  end

  private

  def personal_info_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def photo_params
    params.require(:user).permit(:photo)
  end

  def account_details_params
    params.require(:user).permit(:interests, :languages, :skills)
  end
end
