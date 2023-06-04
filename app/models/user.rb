class User < ApplicationRecord
  # personal details
  validates :name, presence: true
  validates :surname, presence: true
  validates :phone, presence: true
  validates :birthday, presence: true

  # location details
  validates :postal, presence: true
  validates :area, presence: true

  # account details

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  # photo
  validates :photo, presence: true

  # interests etc.
  INTEREST_CATEGORIES = ['Movies', 'Sports', 'Music', 'Books', 'Travel'].freeze
  SKILLSET_CATEGORIES = ['Web Development', 'Data Analysis', 'Graphic Design', 'Project Management'].freeze
  LANGUAGE_SKILLS = ['English', 'Spanish', 'French', 'German', 'Chinese'].freeze
  serialize :interests, Array
  serialize :skillset, Array
  serialize :language_skills, Array
  validates :interests, presence: true
  validates :skillset, presence: true
  validates :language_skills, presence: true

  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  has_many :listings, dependent: :destroy # user's listings refer to their tools/listings on offer to other users
  has_many :bookings, dependent: :destroy # user's bookings refer to the tools/listings that they have requested/agreed to borrow
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
