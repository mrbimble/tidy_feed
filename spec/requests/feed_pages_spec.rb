require 'spec_helper'

describe "Feed pages" do

	let(:user) { FactoryGirl.create(:user) }
	let(:admin) { FactoryGirl.create(:admin) }

	subject { page }

	describe "index" do
		
		describe "as a non-admin user" do
			before do
				sign_in user
				visit feeds_path
			end

			it { should_not have_selector('title', text: 'All Feeds') }
			it { should_not have_selector('h1', text: 'All Feeds') }
		end

		describe "as an admin user" do
			before do
				sign_in admin
				visit feeds_path
			end

			it { should have_selector('title', text: 'All Feeds') }
			it { should have_selector('h1', text: 'All Feeds') }
		end
	end

	describe "new feed page" do
		before do
			sign_in admin
			visit new_feed_path
		end

		it { should have_selector('title', text: 'New Feed') }
		it { should have_selector('h1', text: 'Create a new feed') }
	end

	describe "feed creation" do

		let(:submit) { "Create Feed" }

		before do
			sign_in admin
			visit new_feed_path
		end

		describe "with invalid information" do

			it "should not create a feed" do
				expect { click_button submit }.not_to change(Feed, :count)
			end

			describe "after submission" do
				before { click_button submit }

				it { should have_content('error') }
				it { should have_selector('title', text: 'New Feed') }
			end
		end

		describe "with valid information" do

			before do
				sign_in admin
				visit new_feed_path
				fill_in "Name", with: "Example Site"
				fill_in "Url", with: "http://www.example.com/rss.xml"
			end

			it "should create a feed" do
				expect { click_button submit }.to change(Feed, :count).by(1)
			end

			describe "after saving the feed" do
				before { click_button submit }
				let(:feed) { Feed.find_by_url("http://www.example.com/rss.xml") }

				it { should have_selector('title', text: 'All Feeds') }
				it { should have_selector('div.alert.alert-success', text: 'Feed successfully created.') }
			end
		end
	end
end