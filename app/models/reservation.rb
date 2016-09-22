class Reservation < ActiveRecord::Base
	belongs_to :listing
	belongs_to :user
	validates :start_date, presence: true
	validates :end_date, presence: true

	# Alias for acts_as_taggable_on :tags
  # acts_as_taggable_on :skills, :interests
  # attr_accessor :tag_list
  validate :start_must_be_before_end_time
  validate :start_must_be_from_today

  private

	def start_must_be_before_end_time
	    errors.add(:start_date, "Start date must be before end date") unless
	        start_date < end_date
	end 

	def start_must_be_from_today
	    errors.add(:start_date, "Booking must not begin before today") unless
	        start_date >= Date::current()
	end 

	# def reservation_clash
	# 	@listing.reservations.each do |x|
			
			
	# 	end

end
