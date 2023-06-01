class AddDateToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :date, :date
  end
end
