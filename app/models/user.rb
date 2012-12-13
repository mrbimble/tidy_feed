# == Schema Information
#
# Table name: users
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean(1)      default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :feed_ids
  has_secure_password

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_feeds, through: :relationships, source: :followed

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def stream
    Post.from_feeds_followed_by(self)
  end

  def following?(feed)
    relationships.find_by_followed_id(feed.id)
  end

  def follow!(feed)
    relationships.create!(followed_id: feed.id)
  end

  def unfollow!(feed)
    relationships.find_by_followed_id(feed.id).destroy
  end


  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
