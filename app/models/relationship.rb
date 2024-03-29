# == Schema Information
#
# Table name: relationships
#
#  id          :integer(4)      not null, primary key
#  follower_id :integer(4)		User ID
#  followed_id :integer(4)		Feed ID
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "Feed"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

end
