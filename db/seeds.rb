# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
5.times do |i|
    Post.create(title: "Post Number #{i}", description: "This is the body of post number #{i}")
   end

   user1 = User.create(email: 'abc@gmail.com', password: 'password')
   user2 = User.create(email: 'xyz@gmail.com', password: 'password')

   hotel1 = ["sunshine","sunrise"]
   hotel1.each do |hotel|
    Hotel.create(name: hotel,user_id: user1.id)
   end