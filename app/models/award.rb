class Award < ApplicationRecord
  MAX_IMAGE_SIZE = 5.megabytes

  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :title, presence: true
  validate :validate_image_filetype
  validate :validate_image_filesize

  private

  def validate_image_filetype
    return unless image.attached?

    errors.add(:image, 'Uploaded file must be image') unless image.content_type.in? %w[image/png image/jpeg]
  end

  def validate_image_filesize
    return unless image.attached?

    errors.add(:image, 'Uploaded file must be less 5 MB') if image.byte_size > MAX_IMAGE_SIZE
  end
end
