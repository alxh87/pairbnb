class ReservationJob < ActiveJob::Base
  queue_as :default


  def perform(reservation)
     ReservationMailer.reservation_email(reservation).deliver_now
     ReservationMailer.reservation_owner_email(reservation).deliver_now
  end

end
