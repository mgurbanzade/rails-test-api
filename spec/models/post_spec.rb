require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "update_average method" do
    let!(:post) { Fabricate(:post) }

    it "should update average rating of the post" do
      Fabricate.times(2, :vote, value: 5, post: post)
      Fabricate(:vote, value: 3, post: post)
      expect(post.average_rating).to eq(4.3)
    end
  end
end
