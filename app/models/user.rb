class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable


  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  # personal details first step
  validates :name, :surname, :phone, :birthday, :postal, :area, presence: true
  # account details
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  # # photo second step
  # validates :photo, presence: true

  # # interests etc. third step
  # INTEREST_CATEGORIES = ['Movies', 'Sports', 'Music', 'Books', 'Travel'].freeze
  # SKILLSET_CATEGORIES = ['Web Development', 'Data Analysis', 'Graphic Design', 'Project Management'].freeze
  # LANGUAGE_SKILLS = ['English', 'Spanish', 'French', 'German', 'Chinese'].freeze
  # serialize :interests, Array
  # serialize :skillset, Array
  # serialize :language_skills, Array
  # validates :interests, presence: true
  # validates :skillset, presence: true
  # validates :language_skills, presence: true




  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  has_many :listings, dependent: :destroy # user's listings refer to their tools/listings on offer to other users
  has_many :bookings, dependent: :destroy # user's bookings refer to the tools/listings that they have requested/agreed to borrow
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
