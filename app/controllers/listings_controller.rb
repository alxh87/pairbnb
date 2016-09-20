class ListingsController < ApplicationController
	before_action :require_login
	before_action :set_listing, only: [:show, :edit, :update, :destroy]


	def new
		@listing = Listing.new
	end

  def index
  	if params[:tag]
  		@listings=Listing.tagged_with(params[:tag])
  	else
	    @listings = Listing.all
	  end
  end


  # def show
  #   # set_listing
  # end

	def create
	  @listing = current_user.listings.new(listing_params)
	 	
	  if @listing.save
		  redirect_to @listing
		else
			render 'new'
		end
	end

	# def edit
	# 	# set_listing
	# end
	
  def update	 
	  if @listing.update(listing_params)
		  redirect_to @listing
		else
			render 'edit'
		end
	end

	private
	  def listing_params
	    params.require(:listing).permit(:title, :description, :tag_list)
	  end


	  def set_listing
	  	@listing = Listing.find(params[:id]) 
	  end
end
