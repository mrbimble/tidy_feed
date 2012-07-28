namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Example User",
					 email: "example@tidyfeed.com",
					 password: "foobar",
					 password_confirmation: "foobar")
		admin.toggle!(:admin)
		49.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@tidyfeed.com"
			password = "password"
			User.create!(name: name,
				 		 email: email,
				 		 password: password,
				 		 password_confirmation: password)
		end
	end
end