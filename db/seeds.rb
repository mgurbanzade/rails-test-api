# frozen_string_literal: true

locations = Parallel.map(1..50) { [Faker::Internet.ip_v4_address] }
Location.import [:ip], locations, validate: false

users = Parallel.map(1..100) { |u| ["user_#{u}"] }
User.import [:login], users, validate: false

post_columns = %i[title body author_id location_id]
post_values = Parallel.map(1..300000) do
  [
    Faker::Name.name,
    Faker::Lorem.paragraph,
    rand(1..100),
    rand(1..50)
  ]
end

Post.import post_columns, post_values, recursive: true, validate: false

vote_columns = %i[value post_id]
vote_values = Parallel.map(1..150000) { |v| [rand(1..5), v] }

Vote.import vote_columns, vote_values, recursive: true, validate: false

ActiveRecord::Base.connection.execute("UPDATE posts SET average_rating = (SELECT AVG(votes.value) AS aver FROM votes WHERE votes.post_id = posts.id)")
