class Post < ApplicationRecord
  enum :status, { draft: "draft", published: "published" }

  has_rich_text :content
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  scope :published, -> { where(status: :published) }
  scope :recent, -> { order(created_at: :desc) }

  before_save :set_published_at

  def comment(user, content)
    comments.create!(
      user: user,
      content: content,
    )
  end

  private

  def set_published_at
    if status_changed? && published?
      self.published_at ||= Time.current
    end
  end
end
