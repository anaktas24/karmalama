class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: :home

  def home
    if user_signed_in?
      @default_radius = 50
      @listings = Listing.near([current_user.latitude, current_user.longitude], @default_radius, order: 'distance')
    else
      @listings = Listing.all.order('created_at DESC')
    end

    if params[:query].present?
      @listings = @listings.where(category_type: params[:query])
    end

    if params[:order_by].present? && params[:order].present?
      order_column = params[:order_by] == 'distance' ? 'distance' : params[:order_by]
      order_direction = params[:order] == 'asc' ? 'ASC' : 'DESC'
      @listings = @listings.order(Arel.sql("#{order_column} #{order_direction}"))
    end

    @listings = @listings.limit(24) # Limit the number of listings to display

    puts "Listing Query: #{@listings.to_sql}"

    # Other code in the action
  end





  private

  def user_params
    params.require(:user).permit(:name, :address, :phone)
  end
end
