class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: Settings.micropost.image.display.resize
  end
  validates :content, presence: true,
                      length: {maximum: Settings.micropost.content.maximum}

  validates :image,
            content_type: {
              in: Settings.micropost.image.content_types,
              message: I18n.t("microposts.image.invalid_format")
            },
            size: {
              less_than: Settings.micropost.image.max_size.megabytes,
              message: I18n.t("microposts.image.too_large")
            }
  scope :newest, ->{order(created_at: :desc)}
end
