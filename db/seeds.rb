locations = []

50.times do
  locations << Location.new(ip: Faker::Internet.ip_v4_address)
end

Location.import locations

users = []

100.times do |u|
  users << User.new(login: "user_#{u}")
end

User.import users

posts = []

300000.times do |p|
  posts << Post.new(
                    title: Faker::Name.name,
                    body: Faker::Lorem.paragraph,
                    author_id: rand(1..100),
                    location_id: rand(1..50)
                   )
end

Post.import posts, batch_size: 30

votes = []

150000.times do |v|
  votes << Vote.new(value: rand(1..5), post_id: v)
  votes << Vote.new(value: rand(1..5), post_id: v)
  votes << Vote.new(value: rand(1..5), post_id: v)
end

Vote.import votes, batch_size: 15
