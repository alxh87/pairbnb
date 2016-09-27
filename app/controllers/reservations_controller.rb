class ReservationsController < ApplicationController

	def new
		@listing = Listing.find(params[:listing_id])
		@blocked_dates=@listing.booked_dates
		@reservation = @listing.reservations.new(res_params)
		@reservation.start_date = Date.parse(params[:reservation][:start_date])
		@reservation.end_date = Date.parse(params[:reservation][:end_date])
		@reservation.total_price = find_price_total if @reservation.valid?
		@booked_on=@reservation.unavailable_dates
	end

	def create
		@listing = Listing.find(params[:listing_id])
	  @reservation = @listing.reservations.new(res_params)
	  @reservation.user=current_user
	  @reservation.start_date = Date.parse(params[:reservation][:start_date])
		@reservation.end_date = Date.parse(params[:reservation][:end_date])
	  @reservation.total_price = find_price_total
	  if @reservation.save
	  	ReservationJob.perform_later(@reservation)
		  redirect_to [@listing, @reservation]
		else
			@booked_on=@reservation.unavailable_dates
			render 'new'
			# redirect_to @listing, :flash => { :error => @reservation.errors.messages }
		end
	end

	def edit
		@listing = Listing.find(params[:listing_id])
		@reservation = @listing.reservations.find(params[:id])
	end

	def show
		@listing = Listing.find(params[:listing_id])
		@reservation = @listing.reservations.find(params[:id])
	end

	 def update	 
	 	@listing = Listing.find(params[:listing_id])
		@reservation = @listing.reservations.find(params[:id])
	  if @reservation.update(res_params)
		  redirect_to @listing
		else
			@booked_on=@reservation.unavailable_dates
			render 'edit'
		end
	end

	def destroy
		@listing = Listing.find(params[:listing_id])
		@reservation = @listing.reservations.find(params[:id])
		@reservation.destroy
		respond_to do |format|
			format.html {redirect_to @listing}
			format.js 
		end
		
	end

	  private

	  def res_params
	    params.require(:reservation).permit(:start_date, :end_date, :num_people)
	  end

	  def find_price_total
	  	duration=(@reservation.end_date-@reservation.start_date)
	  	nightprice=duration*@listing.price_per_night
	  	peopleprice=(@reservation.num_people-1)*duration*@listing.price_per_person
	  	totalprice=nightprice+peopleprice
	  	return totalprice
	  end


end