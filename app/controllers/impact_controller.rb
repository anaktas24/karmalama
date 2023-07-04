class ImpactController < ApplicationController
  LEVEL_POINTS_MAPPING = {
    1 => 0,
    2 => 1,
    3 => 2,
    4 => 3,
    5 => 4,
    6 => 5
  }

  def show
    @user = current_user
    @points = @user&.points || 0
    @hours = @user&.hours_worked || 0
    @level = get_user_level(@points)
  end

  private

  def get_user_level(points)
    LEVEL_POINTS_MAPPING.each do |level, required_points|
      return level if points && points >= required_points
    end
    return 1 # Default level is 1 if no matching level is found
  end
end
