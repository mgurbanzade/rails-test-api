Fabricator(:post) do
  title { Faker::Name.name }
  body { Faker::Lorem.paragraph }
  author { Fabricate(:user) }
  location { Fabricate(:location) }
end
