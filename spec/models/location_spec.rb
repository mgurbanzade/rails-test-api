require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "cache_key class method" do
    let!(:locations) { Fabricate.times(5, :location) }
    sleep 1
    let!(:latest) { Fabricate(:location) }
    let(:result) { Location.cache_key(Location.all) }

    it "should return latest updated_at timestamp" do
      expect(result[:stat_record]).to eq(latest.updated_at)
    end

    it "should not return old updated_at timestamps" do
      locations.map do |l|
        expect(result[:stat_record]).to_not eq(l.updated_at)
      end
    end
  end
end
