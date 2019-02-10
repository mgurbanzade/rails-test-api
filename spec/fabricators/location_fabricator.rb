Fabricator(:location) do
  ip { Faker::Internet.ip_v4_address }
end
