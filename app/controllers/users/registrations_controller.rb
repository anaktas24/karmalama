class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    @step = params.dig(:user, :step).to_i || 1
    case @step
    when 1
      @user = User.new(session[:user_step1_params] || {})
      render 'step1'
    when 3
      if session[:user_step1_params].is_a?(Hash)
        @user = User.new(user_params.merge(session[:user_step1_params]))
        render 'step3'
      else
        redirect_to new_user_registration_path(user: { step: 1 })
      end
    else
      redirect_to new_user_registration_path(user: { step: 1 })
    end
  end


  def create
    puts "Create action called!"
    case params[:user][:step].to_i
    when 1
      session[:user_step1_params] = user_params
      redirect_to new_user_registration_path(user: { step: 3 })
    when 3
      if session[:user_step1_params].is_a?(Hash)
        @user = User.new(session[:user_step1_params].merge(user_params))
        @user.points = 0
        @user.level = 1
        if @user.valid?
          @user.save
          session[:user_step1_params] = nil
          sign_in(@user)
          redirect_to root_path
        else
          puts @user.errors.full_messages
          render 'step3'
        end
      else
        redirect_to new_user_registration_path(user: { step: 1 })
      end
    else
      redirect_to new_user_registration_path(user: { step: 1 })
    end
  end


  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :email, :password, :password_confirmation, :name, :surname, :phone, :birthday, :postal, :area, :step,
      { interests: [], skillset: [], language_skills: [] },
      :education_level, :work_level
    ])
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation,
      :name, :surname, :phone, :birthday, :postal, :area, :step,
      { interests: [], skillset: [], language_skills: [] },
      :education_level, :work_level
    )
  end
end
