class Photo < ActiveRecord::Base
  has_and_belongs_to_many :tags
  mount_uploader :picture, PictureUploader
  validates :title, presence: true, length: { minimum: 1 }
  validate :picture_size
  paginates_per 6

  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end