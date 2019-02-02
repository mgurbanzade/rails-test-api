ips = []

51.times do
  ips << Faker::Internet.ip_v4_address
end

users = []

100.times do |u|
  users << User.new(login: "user_#{u}")
end

User.import users

posts = []

300000.times do |p|
  posts << Post.new(
                    title: "sample-title-#{p}",
                    body: "sample-body-#{p}",
                    author_id: rand(1..100),
                    author_ip: ips[rand(0..50)]
                   )
end

Post.import posts, batch_size: 10

votes = []

150000.times do |v|
  votes << Vote.new(value: rand(1..5), post_id: v)
  votes << Vote.new(value: rand(1..5), post_id: v)
  votes << Vote.new(value: rand(1..5), post_id: v)
end

Vote.import votes, batch_size: 10
