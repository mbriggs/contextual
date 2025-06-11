class User < ApplicationRecord
  enum :role, { commenter: "commenter", admin: "admin" }

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  scope :admins, -> { where(role: :admin) }
  scope :commenters, -> { where(role: :commenter) }
end
