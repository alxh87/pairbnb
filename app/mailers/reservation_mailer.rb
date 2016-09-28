class ReservationMailer < ApplicationMailer
	default from: 'alxhdevelopment@gmail.com'
	 
	  def reservation_email(reservation)
	    @reservation = reservation
	    @url  = 'http://example.com/login'
	    mail(to: @reservation.user.email, subject: 'You have made a booking')
	  end

	  def reservation_owner_email(reservation)
	    @reservation = reservation
	    @url  = 'http://example.com/login'
	    mail(to: @reservation.listing.user.email, subject: 'You have a new guest')
	  end

end
