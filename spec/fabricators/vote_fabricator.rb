Fabricator(:vote) do
  value { rand(1..5) }
  post { Fabricate(:post) }
end
