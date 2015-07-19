class Tag < ActiveRecord::Base
  has_and_belongs_to_many :photos
  before_save { self.content = content.downcase }
  validates :content, uniqueness: { case_sensitive: false }, presence: true, length: { minimum: 1 }
end