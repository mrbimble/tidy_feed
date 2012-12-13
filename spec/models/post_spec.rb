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

require 'spec_helper'

describe Post do

	let(:feed) { FactoryGirl.create(:feed) }
	before do
		@post = feed.posts.build(title: "Test Title", creator: "User", link: "link", guid: "LinkID", pubDate: '2012-07-31', content: "Lorem Ipsum")
	end

	subject { @post }

	it { should respond_to(:title) }
	it { should respond_to(:creator) }
	it { should respond_to(:link) }
	it { should respond_to(:guid) }
	it { should respond_to(:feed_id) }
	it { should respond_to(:pubDate) }
	it { should respond_to(:content) }
	its(:feed) { should == feed }

	describe "when feed id is not present" do
		before { @post.feed_id = nil }

		it { should_not be_valid }
	end

	describe "accessible attributes" do
		it "should not allow access to feed_id" do
			expect do
				Post.new(feed_id: feed.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
end
