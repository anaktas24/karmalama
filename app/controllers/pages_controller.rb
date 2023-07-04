class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home


    # if user_signed_in?
      # @default_radius = 50
      # @listings = Listing.near([current_user.latitude, current_user.longitude], @default_radius, order: 'distance').limit(24)
    # else
      @listings = Listing.all.order('created_at DESC').limit(24)
    # end

    if params[:query].present?
      @listings = @listings.where(category_type: params[:query])
    end

    if params[:order_by].present?
      @listings = @listings.order(params[:order_by] => params[:order])
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :phone)
  end
end
