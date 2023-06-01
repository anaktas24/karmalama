class AddPlcToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :postal, :integer
  end
end
