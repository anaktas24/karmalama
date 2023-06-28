class Booking < ApplicationRecord
  belongs_to :listing
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :price_per_hour, presence: true

  validates :status, presence: true, inclusion: { in: %w(pending rejected confirmed expired) }
end
