class Users::RegistrationsController < Devise::RegistrationsController
  def personal_info
    @user = User.new
    render 'devise/registrations/personal_info'
  end

  def create_personal_info
    @user = User.new(personal_info_params)
    if @user.valid?(:personal_info)
      session[:user] = @user.attributes
      if @user.save
        redirect_to new_user_registration_photo_path
      else
        render 'devise/registrations/personal_info'
      end
    else
      render 'devise/registrations/personal_info'
    end
  end

  def photo
    @user = User.new
    render 'devise/registrations/photo'
  end

  def create_photo
    @user = User.new(photo_params)
    if @user.valid?(:photo)
      session[:user].merge!(@user.attributes)
      if @user.save
        redirect_to new_user_registration_account_details_path
      else
        render 'devise/registrations/photo'
      end
    else
      render 'devise/registrations/photo'
    end
  end

  def account_details
    @user = User.new
    render 'devise/registrations/account_details'
  end

  def create_account_details
    @user = User.new(account_details_params)
    if @user.valid?(:account_details)
      @user.attributes = session[:user]
      if @user.save
        session[:user] = nil
        sign_in(@user)
        redirect_to root_path
      else
        render 'devise/registrations/account_details'
      end
    else
      render 'devise/registrations/account_details'
    end
  end

  private

  def personal_info_params
    params.require(:user).permit(:name, :surname, :email, :phone, :birthday, :password, :password_confirmation)
  end

  def photo_params
    params.require(:user).permit(:photo)
  end

  def account_details_params
    params.require(:user).permit(:interests, :skillset, language_skills: [])
  end
end
