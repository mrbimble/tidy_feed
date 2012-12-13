# == Schema Information
#
# Table name: posts
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  link       :string(255)
#  guid       :string(255)
#  creator    :string(255)
#  feed_id    :integer(4)
#  pubDate    :datetime
#  content    :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Post < ActiveRecord::Base
  attr_accessible :content, :creator, :guid, :link, :pubDate, :title
  belongs_to :feed

  validates :feed_id, presence: true

  default_scope order: 'posts.pubDate DESC'


  def self.from_feeds_followed_by(user)
  	followed_feed_ids = "SELECT followed_id FROM relationships WHERE follower_id = #{user.id}"
  	where("feed_id IN (#{followed_feed_ids})", followed_feed_ids: followed_feed_ids)

  	#where("feed_id IN (#{followed_feed_ids}", followed_feed_ids: followed_feed_ids)
  end

  def preview_text
  	max_sentences = 3
  	max_words = 50

  	preview_text = self.content.split('. ').slice(0, max_sentences).join('. ')
  end
end
