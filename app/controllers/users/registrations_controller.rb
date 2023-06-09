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
      if session[:user_step1_params].is_a?(Hash) && session[:user_step2_params].is_a?(Hash)
        @user = User.new(session[:user_step1_params].merge(session[:user_step2_params].except("picture"))) if session[:user_step1_params] && session[:user_step2_params]
        render 'step3'
      else
        redirect_to new_user_registration_path(user: { step: 1 }) and return
      end
    end
  end


  def create
    case params[:user][:step].to_i
    when 1
      session[:user_step1_params] = user_params
      redirect_to new_user_registration_path(user: { step: 2 }) and return
    when 2
      @user = User.new(session[:user_step1_params]) if session[:user_step1_params]

      if @user && @user.valid?
        session[:user_step2_params] = user_params
        redirect_to new_user_registration_path(user: { step: 3 }) and return
      else
        render 'step2'

      end
    when 3
      if session[:user_step1_params].is_a?(Hash) && session[:user_step2_params].is_a?(Hash)
        @user = User.new(session[:user_step1_params].merge(session[:user_step2_params]))

        if @user && @user.valid?
          if params[:user][:picture].present?
            # Assign the picture to the user's profile attribute
            @user.profile.picture = params[:user][:picture]
          end

          @user.save
          session[:user_step1_params] = nil
          session[:user_step2_params] = nil

          sign_in(@user)
          flash[:notice] = "Registration completed successfully!"
          redirect_to root_path and return
        end
      end

      render turbo_stream: turbo_stream.replace('registration-form', partial: 'step3_form', locals: { user: @user })
    else
      redirect_to root_path
    end
  end









  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :name, :surname, :phone, :birthday, :postal, :area, :step, :picture])
  end


  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :surname, :phone, :birthday, :postal, :area, :step, :picture)
  end
end
