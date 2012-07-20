FactoryGirl.define do
	factory :user do
		name	"Nick Schneider"
		email	"mrbimble@comcast.net"
		password	"foobar"
		password_confirmation "foobar"
	end
end