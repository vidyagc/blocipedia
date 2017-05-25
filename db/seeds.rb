# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


10.times do
    User.create!(
        email: Faker::Internet.unique.email,
        password: 'password', 
        password_confirmation: 'password'
    )
end 
users = User.all

30.times do
    Wiki.create!(
        title: Faker::Lorem.unique.sentence,
        body: Faker::Lorem.unique.paragraph,
        private: Faker::Boolean.boolean(0.0), # was optional param of 'true_ratio = 0.5'
        user: users.sample
    ) 
end 

 puts "Seed finished"
 puts "#{User.count} users created"
 puts "#{Wiki.count} wikis created"