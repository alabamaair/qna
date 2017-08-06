require 'rails_helper'

describe 'Answers API' do
  describe 'GET /answers' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question_id: question.id) }
    let(:access_token) { create(:access_token) }
    let(:obj_name) { 'answers' }

    it_behaves_like 'API Authenticable'

    it_behaves_like 'API /index Authenticable'

    def do_request(options={})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge!(options)
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question_id: question.id) }
    let!(:comments){ create_list(:comment, 2, commentable: answer) }
    let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
    let(:obj_name) { 'answer' }

    it_behaves_like 'API Authenticable'

    it_behaves_like 'API /show Authenticable'

    def do_request(options={})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge!(options)
    end
  end

  describe 'POST /create' do
    let!(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:obj_name) { 'answer' }

    it_behaves_like 'API /create Authenticable'

    def do_request(options={})
      post "/api/v1/questions/#{question.id}/answers/", params: { format: :json }.merge!(options)
    end
  end
end
