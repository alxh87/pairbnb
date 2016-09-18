class ListingsController < ApplicationController
	before_action :require_login

	def new
		@listing = Listing.new
	end

  def index
    @listings = Listing.all
  end

  def show
    @listing = Listing.find(params[:id])
  end

	def create
	  @listing = Listing.new(listing_params)
	 	@listing.user_id = current_user.id
	  if @listing.save
		  redirect_to @listing
		else
			render 'new'
		end
	end

	def edit
		@listing=Listing.find(params[:id])
	end
	
  def update
  	@listing = Listing.find(params[:id])
	 
	  if @listing.update(listing_params)
		  redirect_to @listing
		else
			render 'edit'
		end
	end

	private
	  def listing_params
	    params.require(:listing).permit(:title, :description)
	  end

end
