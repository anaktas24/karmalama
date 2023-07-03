class Job < ApplicationRecord
  enum difficulty: [:easy, :medium, :hard]
  validates :difficulty, presence: true
  validates :points_awarded, presence: true, numericality: { greater_than_or_equal_to: 0 }
  has_many :users, through: :listings
end
