class PostSerializer
  include FastJsonapi::ObjectSerializer
  attribute :title, :body

  attribute :author_ip do |obj|
    obj.author_ip.to_s
  end
end
