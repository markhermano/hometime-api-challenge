class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :email, :first_name, :last_name, :phone, presence: true
  validates_uniqueness_of :email
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

  serialize :phone, Array
end
