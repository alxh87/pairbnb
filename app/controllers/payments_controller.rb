class PaymentsController < ApplicationController

  before_action :require_login

  def new

    @listing = Listing.find(params[:listing_id])
    @blocked_dates=@listing.booked_dates unless @blocked_dates
    @reservation = @listing.reservations.new(res_params)
    @reservation.user=current_user
    @reservation.start_date = Date.parse(params[:reservation][:start_date])
    @reservation.end_date = Date.parse(params[:reservation][:end_date])
    @reservation.total_price = find_price_total


    if @reservation.valid?
      @client_token = Braintree::ClientToken.generate
      # @reservation = Reservation.find(params[:id])
      @payment = Payment.new
      # @payment = @reservation.payment.new
    else
      render 'reservations/new'
      # redirect_to new_listing_reservation_path(:listing=>@listing, :reservation=>@reservation)
    end
  end

  def create

    @listing = Listing.find(params[:listing_id])
    @reservation = @listing.reservations.new
    @reservation.user=current_user
    @reservation.num_people=params[:payment][:num_people]
    @reservation.start_date = Date.parse(params[:payment][:start_date])
    @reservation.end_date = Date.parse(params[:payment][:end_date])
    @reservation.total_price = find_price_total

    if @reservation.valid?

      amount = params[:payment][:total_price]
      nonce = params[:payment_method_nonce]

      render action: :new and return unless nonce

      @result = Braintree::Transaction.sale(
        amount: amount,
        payment_method_nonce: params[:payment_method_nonce]
      )

      if @result.success?

        @reservation.save
        ReservationJob.perform_later(@reservation)
        payment = Payment.create(reservation_id: @reservation.id, braintree_payment_id: @result.transaction.id, status: @result.transaction.status, fourdigit: @result.transaction.credit_card_details.last_4)

          redirect_to listing_reservation_path(:listing_id => payment.reservation.listing.id, :id => payment.reservation.id), notice: "Congratulations! Your transaction is successful!"
      else
      	
          Payment.create(reservation_id: params[:payment][:reservation_id], braintree_payment_id: @result.transaction.id, status: @result.transaction.status, fourdigit: @result.transaction.credit_card_details.last_4)
          flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
          @client_token = Braintree::ClientToken.generate
          @reservation = Reservation.find(params[:payment][:reservation_id])
          @payment = Payment.new
          render :new
      end
    else
      #if reservation not valid
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