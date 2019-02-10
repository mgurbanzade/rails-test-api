require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  describe 'GET #index' do
    let(:locations) { Fabricate.times(3, :location) }

    before do
      locations.map { |l| Fabricate.times(3, :post, location: l) }
    end

    context 'should return locations with users' do
      it 'returns location ip key and user logins array' do
        get :index, format: :json
        ip = locations.first.ip
        users_list = locations.first.users.pluck(:login).uniq
        expect(JSON.parse(response.body).first).to eq({ip => users_list})
      end
    end
  end
end
