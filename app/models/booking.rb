class Booking < ApplicationRecord
  validates :status, inclusion: { in: ['Pending', 'Accepted', 'Rejected'] }
  belongs_to :listing
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :price_per_hour, presence: true

  validates :status, presence: true, inclusion: { in: ['Pending', 'Accepted', 'Rejected'] }
end
