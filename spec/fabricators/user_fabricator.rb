Fabricator(:user) do
  login { Faker::Internet.username }
end
