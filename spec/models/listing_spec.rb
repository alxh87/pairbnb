
require 'rails_helper'

RSpec.describe Listing, type: :model do

	context "database: " do
    it "should have title" do
			should have_db_column(:title).of_type(:string)
		end
		it "should have description" do
			should have_db_column(:description).of_type(:text)
		end
		it "should have user id column" do
			should have_db_column(:user_id).of_type(:integer)
		end
		it "should have avatars" do
    	should have_db_column(:avatars).of_type(:json)
    end
    it "should have prices per night and per person" do
    	should have_db_column(:price_per_person).of_type(:integer)
    	should have_db_column(:price_per_night).of_type(:integer)
    end
  end
      #         should have_db_column(:camera_aperture).
      #           with_options(precision: 1, null: false)
      #       end

	context "validation: " do
		it { is_expected.to validate_presence_of(:title) }
		it { is_expected.to validate_presence_of(:description) }
	end

	context "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:reservations) }
  end

end
