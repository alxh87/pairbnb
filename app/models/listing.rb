class Listing < ActiveRecord::Base

	validates :title, presence: true
	belongs_to :user
	has_many :reservations
	mount_uploaders :avatars, ImagesUploader
	acts_as_taggable
	# Alias for acts_as_taggable_on :tags
  # acts_as_taggable_on :skills, :interests
  # attr_accessor :tag_list

  def booked_dates
  	dates=[]
  	self.reservations.each do |r|
  		range = r.start_date.to_date..(r.end_date.to_date-1)
  		range=range.to_a
  		range.each do |x|
  			dates<<x.strftime("%Y-%m-%d")
  			end
  		end
  	return dates
  end

end
