class AddColumnsToListings < ActiveRecord::Migration
  def change
  	add_column :listings, :price_per_night, :integer
  	add_column :listings, :price_per_person, :integer
  	add_column :listings, :location, :string
  end
end
