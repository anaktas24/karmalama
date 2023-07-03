class Level < ApplicationRecord

  validates :number, presence: true
  validates :points, presence: true
  validates :image, presence: true
end
