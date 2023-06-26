class AddDescriptionToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :description, :text
  end
end
