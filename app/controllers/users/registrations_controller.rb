class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    @step = params.dig(:user, :step).to_i || 1

    case @step
    when 1
      @user = User.new
      render 'step1'
    when 2
      @user = User.new(session[:user_step1_params]&.merge(user_params) || {})
      render 'step2'
    when 3
      @user = User.new(session[:user_step1_params].merge(session[:user_step2_params])) if session[:user_step1_params] && session[:user_step2_params]
      render 'step3'
    else
      redirect_to new_user_registration_path(user: { step: 1 })
    end
  end

  def create
    @step = params.dig(:user, :step).to_i || 1

    case @step
    when 1
      session[:user_step1_params] = user_params
      redirect_to new_user_registration_path(user: { step: 2 }) and return
    when 2
      @user = User.new(session[:user_step1_params].merge(user_params)) if session[:user_step1_params]

      if @user && @user.valid?
        session[:user_step2_params] = user_params
        redirect_to new_user_registration_path(user: { step: 3 }) and return
      else
        @user ||= User.new
        render 'step2'
      end
    when 3
      @user = User.new(session[:user_step1_params].merge(session[:user_step2_params])) if session[:user_step1_params] && session[:user_step2_params]

      if @user && @user.valid?
        @user.save
        session[:user_step1_params] = nil
        session[:user_step2_params] = nil
        redirect_to root_path and return
      else
        render 'step3'
      end
    else
      redirect_to new_user_registration_path(user: { step: 1 }) and return
    end
  end







  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :name, :surname, :phone, :birthday, :postal, :area, :step])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :surname, :phone, :birthday, :postal, :area, :step)
  end
end
