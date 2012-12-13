FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person_#{n}" }
		sequence(:email) { |n| "Person_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end

	factory :feed do
		url "http://www.example.com/rss.xml"
		name "Example Site"
	end

	factory :post do
		title "Example Post Title"
		link "http://www.example.com/mystory"
		guid "http://www.example.com/permalink"
		creator "Example User"
		content "Lorem Ipsum"
		feed
	end
end