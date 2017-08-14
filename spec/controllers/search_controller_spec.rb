require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #show' do
    before { get :show, params: { query: 'Query test', resource: 'Questions' } }

    it 'assigns query to @query' do
      expect(assigns(:query)).to eq 'Query test'
    end

    it 'assigns resource to @resource' do
      expect(assigns(:resource)).to eq 'Questions'
    end

    it 'render show view' do
      expect(response).to render_template(:show)
    end
  end
end