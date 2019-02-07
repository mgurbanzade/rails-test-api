# frozen_string_literal: true

locations = (1..50).map { [Faker::Internet.ip_v4_address] }
Location.import [:ip], locations, validate: false

users = (1..100).map { |u| ["user_#{u}"] }
User.import [:login], users, validate: false

post_columns = %i[title body author_id location_id]
post_values = (1..300000).map do
  [
    Faker::Name.name,
    Faker::Lorem.paragraph,
    rand(1..100),
    rand(1..50)
  ]
end

Post.import post_columns, post_values, recursive: true, validate: false

vote_columns = %i[value post_id]
vote_values = (1..150000).map { |v| [rand(1..5), v] }

Vote.import vote_columns, vote_values, recursive: true, validate: false

ActiveRecord::Base.connection.execute("UPDATE posts SET average_rating = (SELECT AVG(votes.value) AS aver FROM votes WHERE votes.post_id = posts.id)")
