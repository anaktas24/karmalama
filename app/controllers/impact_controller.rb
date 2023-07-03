class ImpactController < ApplicationController
  def index
    @user = current_user
    @completed_bookings = @user.bookings
  end
end
