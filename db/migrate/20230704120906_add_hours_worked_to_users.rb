class AddHoursWorkedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hours_worked, :integer
  end
end
