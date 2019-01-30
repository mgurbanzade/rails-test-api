class PostSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :body

  attribute :author_ip do |obj|
    obj.author_ip.to_s
  end
end
