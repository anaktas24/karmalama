class AddPricePerHourToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :price_per_hour, :float
  end
end
