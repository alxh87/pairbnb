class ChangeStartendToStartdateenddate < ActiveRecord::Migration
  def change
  	  	remove_column :reservations, :start
  	  	remove_column :reservations, :end

  			add_column :reservations, :start_date, :datetime
  			add_column :reservations, :end_date, :datetime
  end
end
