class ListingsController < ApplicationController
	before_action :require_login
	before_action :set_listing, only: [:show, :edit, :update, :destroy]


	def new
		@listing = Listing.new
	end
	
  def index
  	listings_per_page = 5
    params[:page] = 1 unless params[:page]
    first_listing = (params[:page].to_i - 1 ) * listings_per_page
    
  	if params[:tag]
  		listings=Listing.tagged_with(params[:tag])
  	else
	    listings = Listing.all
	  end

	  @total_pages = listings.count / listings_per_page
	  if listings.count % listings_per_page > 0
      @total_pages += 1
    end
    @listings = listings[first_listing...(first_listing + listings_per_page)]
 
  end

  def search
  	
	  @listings = Listing.search(params[:term], fields: ["name", "location", "description"], mispellings: {below: 5})
	  if @listings.blank?
	    redirect_to listings_path, flash:{danger: "no successful search result"}
	  else

	  			listings = @listings

	  	  	listings_per_page = 5
	  	    params[:page] = 1 unless params[:page]
	  	    first_listing = (params[:page].to_i - 1 ) * listings_per_page
	  	    
	  		  @total_pages = listings.count / listings_per_page
	  		  if listings.count % listings_per_page > 0
	  	      @total_pages += 1
	  	    end
	  	    @listings = listings[first_listing...(first_listing + listings_per_page)]
	  	 



	    render :index
	  end
  end




  def show
  	@blocked_dates=@listing.booked_dates
   	@reservation = Reservation.new
  end


	def create
		params[:listing][:tag_list]=params[:listing][:tag_list].join(",") if params[:listing][:tag_list]
	  @listing = current_user.listings.create(listing_params)

	  if @listing.save
		  redirect_to @listing
		else
			render 'new'
		end
	end

	# def edit
	# 	set_listing
	# 	@listing.tag_list = @listing.tag_list.join(", ")
	# 	byebug
	# end
	
  def update	

  	params[:listing][:tag_list]=params[:listing][:tag_list].join(",") if params[:listing][:tag_list]
	   
	  if @listing.update(listing_params)

		  redirect_to @listing
		else
			render 'edit'
		end
	end

	def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
 
    redirect_to listings_path
  end



	# def tag_list
 #    caller[0][/`([^']*)'/, 1] == 'block in validate' ? @tag_list : tags.map(&:name).join(", ")
 #  end

 #  def tag_list=(names)
 #    @tag_list = names.split(",").map do |n|
 #      #self.tags.find_or_initialize_by_name(name: n.strip) #uncomment this if you want invalid tags to show in tag list
 #      Tag.find_or_initialize_by_name(name: n.strip)
 #    end
 #  end



  private

    # def save_tags
    #   self.tags = Tag.transaction do
    #     @tag_list.each(&:save)
    #   end
    # end

	  def listing_params
	    params.require(:listing).permit(:title, :description, :tag_list, {avatars:[]}, :price_per_night, :price_per_person, :location)
	  end


	  def set_listing
	  	@listing = Listing.find(params[:id]) 
	  end
end
