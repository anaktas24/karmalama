class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    @step = params.dig(:user, :step).to_i || 1

    case @step
    when 1
      @user = User.new
      render 'step1'
    when 2
      @user = User.new(session[:user_step1_params].merge(user_params)) if session[:user_step1_params]
      render 'step2'
    when 3
      # Code for step 3
    else
      redirect_to new_user_registration_path(user: { step: 1 })
    end
  end

  def create
    @step = params.dig(:user, :step).to_i || 1

    case @step
    when 1
      session[:user_step1_params] = user_params
      redirect_to new_user_registration_path(user: { step: 2 })
    when 2
      @user = User.new(user_params)
      if session[:user_step1_params].present?
        @user.assign_attributes(session[:user_step1_params])
      end
      if @user.valid?
        if @user.save
          session[:user_step1_params] = nil
          redirect_to new_user_registration_path(user: { step: 3 })
        else
          puts @user.errors.full_messages # Add this line
          render 'step2'
        end
      else
        puts @user.errors.full_messages # Add this line
        render 'step2'
      end
    when 3
      # Code for step 3
      redirect_to root_path
    else
      redirect_to new_user_registration_path(user: { step: 1 })
    end
  end




  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :surname, :phone, :birthday, :postal, :area)
  end
end
