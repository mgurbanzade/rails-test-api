require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'POST #create' do
    context 'valid params' do
      let!(:valid_params) {
        {
          title: 'test-title',
          body: 'test-body',
          author_login: 'test-user',
          post: {
            title: 'test-title',
            body: 'test-body'
          }
        }
      }

      it 'creates new post in database' do
        expect { post :create, params: valid_params, format: :json}.to change(Post, :count).by(1)
      end

      it 'returns json of the created post' do
        post :create, params: valid_params, format: :json
        expect(response.content_type).to eq('application/json')
        expect(JSON.parse(response.body)['body']).to eq('test-body')
      end
    end

    context 'invalid params' do
      let!(:invalid_params) {
        {
          title: 'test-title',
          body: 'test-body',
          author_login: 'test-user',
          post: {
            body: 'test-body'
          }
        }
      }

      before do
        post :create, params: invalid_params, format: :json
      end

      it 'does not create new post in database' do
        expect { post :create, params: invalid_params, format: :json }.to_not change(Post, :count)
      end

      it 'returns json messages' do
        expect(JSON.parse(response.body)).to eq(["Title can't be blank"])
      end

      it 'sets unprocessable entity status' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'POST #rate' do
    let!(:ppost) { Fabricate(:post) }

    context 'valid params' do
      it 'creates a new post vote in database' do
        expect { post :rate, params: {id: ppost.id, vote: 4}, format: :json }.to change(ppost.votes, :count).by(1)
      end

      it 'returns new average rating of the post with content type of json' do
        Fabricate(:vote, value: 5, post: ppost)
        post :rate, params: {id: ppost.id, vote: 1}, format: :json
        expect(JSON.parse(response.body)).to eq(3.0)
      end
    end

    context 'invalid params' do
      it 'does not create a new vote with invalid values' do
        expect { post :rate, params: {id: ppost.id, vote: 6}, format: :json }.to_not change(ppost.votes, :count)
        expect { post :rate, params: {id: ppost.id, vote: 0}, format: :json }.to_not change(ppost.votes, :count)
      end

      it 'does not create a new vote with missing params' do
        expect { post :rate, params: {id: ppost.id}, format: :json }.to_not change(ppost.votes, :count)
      end

      it 'returns error messages' do
        post :rate, params: {id: ppost.id}, format: :json
        expect(JSON.parse(response.body)).to eq(["Value can't be blank", "Value is not included in the list"])
      end
    end
  end

  describe 'GET #most_rated' do
    let!(:posts) { Fabricate.times(19, :post) }
    let!(:last) { Fabricate(:post) }

    before do
      posts.map { |p| Fabricate.times(3, :vote, value: rand(1..4), post: p) }
      Fabricate.times(3, :vote, value: 5, post: last)
    end

    context 'should return most rated posts' do
      it 'returns most rated posts' do
        get :most_rated, format: :json
        result = JSON.parse(response.body)

        expect(result.first['body']).to eq(last.body)
      end
    end

    context 'should return page results' do
      it 'returns second page results' do
        get :most_rated, params: {page: 2}, format: :json
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end
end
