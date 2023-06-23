class AddStep3ToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :interests, :text
    add_column :users, :skillset, :text
    add_column :users, :language_skills, :text
    add_column :users, :education_level, :integer
    add_column :users, :work_level, :integer
  end
end
