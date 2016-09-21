class ListingsController < ApplicationController
	before_action :require_login
	before_action :set_listing, only: [:show, :edit, :update, :destroy, :remove_image_at_index]


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

	def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
 
    redirect_to listings_path
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

  def remove_image_at_index
    	byebug
    remain_images = @listing.avatars # copy the array
    deleted_image = remain_images.delete_at(params[:image_index].to_i) # delete the target image
    deleted_image.try(:remove!) # delete image from S3
    @listing.avatars = remain_images # re-assign back
    @listing.save
 		redirect_to @listing
  end



  private

    def save_tags
      self.tags = Tag.transaction do
        @tag_list.each(&:save)
      end
    end

	  def listing_params
	  	# params[:listing][:avatars] = []
	  	params[:listing][:avatars] << params[:listing][:avatars]
	    params.require(:listing).permit(:title, :description, :tag_list, {avatars:[]})
	  end


	  def set_listing
	  	@listing = Listing.find(params[:id]) 
	  end
end
