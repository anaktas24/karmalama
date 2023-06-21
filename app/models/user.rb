class User < ApplicationRecord
  attr_accessor :step, :admin

  #ADMIN OR NO ADMIN
  ROLES = {admin: 'admin'}.freeze

  def assign_admin_role
    update(role: ROLES[:admin])
  end




  # Devise modules
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  has_one_attached :picture
  # Validations
  validates :name, :surname, :phone, :birthday, :postal, :area, presence: true
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

  validates :interests, presence: true
  validates :skillset, presence: true
  validates :language_skills, presence: true
  validates :education_level, presence: true
  validates :work_level, presence: true

  has_many :listings, dependent: :destroy
  has_many :bookings, dependent: :destroy

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def initialize(attributes = {})
    super
    self.interests ||= []
    self.skillset ||= []
    self.language_skills ||= []
  end
end
