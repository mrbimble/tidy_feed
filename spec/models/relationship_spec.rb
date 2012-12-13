# == Schema Information
#
# Table name: relationships
#
#  id          :integer(4)      not null, primary key
#  follower_id :integer(4)		this will be the user ID
#  followed_id :integer(4)		this will be the feed id
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Relationship do

	let(:follower) { FactoryGirl.create(:user) }
	let(:followed_feed) { FactoryGirl.create(:feed) }
	let(:relationship) { follower.relationships.build(followed_id: followed_feed) }

	subject { relationship }

	it { should be_valid }

	describe "accessible attributes" do
		it "should not allow access to follower_id (user_id)" do
			expect do
				Relationship.new(follower_id: follower.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "follower methods" do
		it { should respond_to(:follower) }
		it { should respond_to(:followed) }
		its(:follower) { should == follower }
		its(:followed_feed) { should == followed }
	end

	describe "when followed id (feed id) is not present" do
		before { relationship.followed_id = nil }
		it { should_not be_valid }
	end

	describe "when follower id (user id) is not present" do
		before { relationship.follower_id = nil }
		it { should_not be_valid }
	end
end
