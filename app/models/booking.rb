class Booking < ApplicationRecord
  validates :status, inclusion: { in: ['Pending', 'Accepted', 'Rejected', 'Completed'] }
  belongs_to :listing
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :points, presence: true

  validates :status, presence: true, inclusion: { in: ['Pending', 'Accepted', 'Rejected', 'Completed'] }
end
