class User < ApplicationRecord
  attr_accessor :step
  # enum role: { regular: 0, admin: 1 }

  # def admin?
  #   role == 'admin'
  # end

  # Devise modules
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  has_one_attached :picture
  # Validations
  validates :name, :surname, :phone, :birthday, :postal, :area, presence: true, unless: :admin?
  validates :interests, :skillset, :language_skills, :education_level, :work_level, presence: true, unless: :admin?

  validates :email, presence: true
  validates_uniqueness_of :email
  #validates :email, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  def password_required?
    password.present? || password_confirmation.present?
  end

  # Step 3 attributes
  serialize :interests, Array
  serialize :skillset, Array
  serialize :language_skills, Array
  enum education_level: { no_education: 0, high_school: 25, college: 50, university: 75, post_graduate: 100 }
  enum work_level: { unemployed: 0, part_time: 25, full_time: 50, self_employed: 75, entrepreneur: 100 }

  INTEREST_CATEGORIES = ['Movies', 'Sports', 'Music', 'Books', 'Travel'].freeze
  SKILLSET_CATEGORIES = ['Web Development', 'Data Analysis', 'Graphic Design', 'Project Management'].freeze
  LANGUAGE_SKILLS = ['English', 'Spanish', 'French', 'German', 'Chinese'].freeze

  has_many :listings, dependent: :destroy
  has_many :bookings, dependent: :destroy
  attribute :about_me, :text

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def initialize(attributes = {})
    super
    self.interests ||= []
    self.skillset ||= []
    self.language_skills ||= []
  end


end
