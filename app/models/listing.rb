class Listing < ActiveRecord::Base

	validates :title, presence: true
	belongs_to :user
	has_many :reservations
	mount_uploaders :avatars, ImagesUploader
	acts_as_taggable
	# Alias for acts_as_taggable_on :tags
  # acts_as_taggable_on :skills, :interests
  # attr_accessor :tag_list

end
