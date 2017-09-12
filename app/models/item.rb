class Item < ApplicationRecord
  attr_accessor :upload
  belongs_to :project
  
  MAX_FILESIZE = 10.megabytes
  
  validates :name, presence: true, uniqueness: true
  validates :upload, presence: true
  
  validate :uploaded_file_size
  
  private
  
  def uploaded_file_size
    if upload
      errors.add(:upload, "File size must be less than 
                          #{self.class::MAX_FILESIZE}") unless upload.size <= self.class::MAX_FILESIZE
    end
  end
  
end
