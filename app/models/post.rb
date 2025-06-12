class Post < ApplicationRecord
  enum :status, { draft: "draft", published: "published" }

  has_rich_text :content
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  scope :published, -> { where(status: :published) }
  scope :recent, -> { order(created_at: :desc) }

  before_save :set_published_at
  before_save :set_excerpt_if_blank

  def comment(user, content)
    comments.create!(
      user: user,
      content: content,
    )
  end

  def auto_excerpt(limit: 160)
    return "" if content.blank?

    # Convert rich text to plain text, then create excerpt
    plain_text = content.to_plain_text.strip.gsub(/\s+/, " ")
    return plain_text if plain_text.length <= limit

    truncated = plain_text.truncate(limit, separator: " ", omission: "")

    "#{truncated}..."
  end

  private def set_published_at
    if status_changed? && published?
      self.published_at ||= Time.current
    end
  end

  private def set_excerpt_if_blank
    if excerpt.blank? && content.present?
      self.excerpt = auto_excerpt
    end
  end
end
