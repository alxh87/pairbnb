class ReservationsController < ApplicationController

	def new
		@listing = Listing.find(params[:id])
		@reservation = Reservation.new
	end

	def create
		@listing = Listing.find(params[:listing_id])
	  @reservation = @listing.reservations.create(res_params)
	  @reservation.user=current_user
	  if @reservation.save
		  redirect_to @listing
		else
			
			redirect_to @listing, :flash => { :error => @reservation.errors.messages }
		end
	end


	  private


	  def res_params
	    params.require(:reservation).permit(:start_date, :end_date)
	  end


end