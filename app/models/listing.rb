class Listing < ActiveRecord::Base
	 validates :title, presence: true
	 belongs_to :user

	acts_as_taggable # Alias for acts_as_taggable_on :tags
  # acts_as_taggable_on :skills, :interests
  attr_accessor :title, :tag_list

end
