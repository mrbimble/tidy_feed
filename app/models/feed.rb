# == Schema Information
#
# Table name: feeds
#
#  id         :integer(4)      not null, primary key
#  url        :string(255)
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Feed < ActiveRecord::Base
  attr_accessible :name, :url

  validates :name, presence: true
  validates :url, presence: true
  
  has_many :posts, dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  
end
