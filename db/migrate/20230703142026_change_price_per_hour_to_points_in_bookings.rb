class ChangePricePerHourToPointsInBookings < ActiveRecord::Migration[7.0]
  def change
    change_column :bookings, :price_per_hour, :integer, default: 0
    rename_column :bookings, :price_per_hour, :points
  end
end
