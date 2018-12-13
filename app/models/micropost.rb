class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content_length}
  validate :picture_size
  scope :newest, ->{order created_at: :desc}
  scope :microposts_of_user, ->(id, following_ids) do
    where "user_id IN (?) OR user_id = ?", following_ids, id
  end

  private

  def picture_size
    return unless picture.size > Settings.micropost.picture_size.megabytes
    errors.add(:picture, I18n.t("models.micropost.size_max"))
  end
end
