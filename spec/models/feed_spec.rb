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

require 'spec_helper'

describe Feed do

	let(:user) { FactoryGirl.create(:user) }
	before do
		#This code is wrong
		@feed = Feed.new(url: "htt://www.example.com", name: "Example Site")
	end

	subject { @feed }

	it { should respond_to(:url) }
	it { should respond_to(:name) }
	it { should respond_to(:reverse_relationships) }
	it { should respond_to(:followers) }
	it { should respond_to(:posts) }

	describe "post associations" do
		before { @feed.save }
		let!(:older_post) do
			FactoryGirl.create(:post, feed: @feed, pubDate: 1.day.ago)
		end
		let!(:newer_post) do
			FactoryGirl.create(:post, feed: @feed, pubDate: 1.hour.ago)
		end

		it "should have the right posts in the right order" do
			@feed.posts.should == [newer_post, older_post]
		end

		it "should destroy associated posts" do
			posts = @feed.posts
			@feed.destroy
			posts.each do |post|
				Post.find_by_id(post.id).should be_nil
			end
		end
	end
end
