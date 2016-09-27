class Reservation < ActiveRecord::Base
	belongs_to :listing
	belongs_to :user
  has_many :payments
	validates :start_date, presence: true
	validates :end_date, presence: true

	# Alias for acts_as_taggable_on :tags
  # acts_as_taggable_on :skills, :interests
  # attr_accessor :tag_list
  validate :start_must_be_before_end_time
  validate :start_must_be_from_today
  validate :check_availability

  def unavailable_dates
        previous_reserv_array = Reservation.where(listing_id: self.listing_id)
        dates=[]
        previous_reserv_array.each do |r|
            range = r.start_date.to_date..(r.end_date.to_date-1)
            (self.start_date.to_date..(self.end_date.to_date-1)).each do |date|
             dates<<date.strftime("%Y-%m-%d") if range === date
            end
        end
        return dates
  end
  
  private

	def start_must_be_before_end_time
	    errors.add(:start_date, " must be before end date") unless
	        start_date < end_date
	end 

	def start_must_be_from_today
	    errors.add(:start_date, "Booking must not begin before today") unless
	        start_date >= Date::current()
	end 

	def check_availability
        previous_reserv_array = Reservation.where(listing_id: self.listing_id)
        x = 0

        previous_reserv_array.each do |r|
            range = r.start_date.to_date..(r.end_date.to_date-1)

            (self.start_date.to_date..(self.end_date.to_date-1)).each do |date|
             x = 1 if range === date
            end

        end

    
        errors.add(:dates, " are already booked") unless x == 0
        
    end

	# def reservation_clash
	# 	@listing.reservations.each do |x|

			
	# 	end

end
