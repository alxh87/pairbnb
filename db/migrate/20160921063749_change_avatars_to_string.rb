class ChangeAvatarsToString < ActiveRecord::Migration
  def change
  	remove_column :users, :avatars
  	add_column :users, :avatar, :string
  end
end
