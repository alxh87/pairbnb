class AddColumnsToReservations < ActiveRecord::Migration
  def change
  	add_column :reservations, :num_people, :integer
  	add_column :reservations, :total_price, :integer
  end
end
