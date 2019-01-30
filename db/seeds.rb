100.times do |u|
  User.create(login: Faker::Internet.username)

  20.times do |p|
    Post.create(
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph,
      author: User.last,
      author_ip: u < 50 ? Faker::Internet.ip_v4_address : Post.order(Arel.sql('RANDOM()')).limit(1).first.author_ip.to_s
    )

    Post.last.votes.create(value: rand(1..5)) if p < 10
  end
end
