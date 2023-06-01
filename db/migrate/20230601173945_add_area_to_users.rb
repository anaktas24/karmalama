class AddAreaToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :area, :string
  end
end
