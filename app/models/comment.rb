class Comment < ApplicationRecord
  belongs_to :post

  validates :author_name, presence: true
  validates :author_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :content, presence: true

  scope :approved, -> { where.not(approved_at: nil) }
  scope :pending, -> { where(approved_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def approved?
    approved_at.present?
  end

  def approve!
    update!(approved_at: Time.current)
  end

  def unapprove!
    update!(approved_at: nil)
  end
end
