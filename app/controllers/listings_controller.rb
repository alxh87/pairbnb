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
	  if @listing.update(listing_params)
		  redirect_to @listing
		else
			render 'edit'
		end
	end


	def tag_list
    caller[0][/`([^']*)'/, 1] == 'block in validate' ? @tag_list : tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    @tag_list = names.split(",").map do |n|
      #self.tags.find_or_initialize_by_name(name: n.strip) #uncomment this if you want invalid tags to show in tag list
      Tag.find_or_initialize_by_name(name: n.strip)
    end
  end

  private

    def save_tags
      self.tags = Tag.transaction do
        @tag_list.each(&:save)
      end
    end

	  def listing_params
	    params.require(:listing).permit(:title, :description, :tag_list)
	  end


	  def set_listing
	  	@listing = Listing.find(params[:id]) 
	  end
end
