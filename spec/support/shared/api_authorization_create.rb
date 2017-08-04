shared_examples_for 'API /create Authenticable' do

  context 'unauthorized' do
    context 'without access token' do
      it 'returns 401 status if there is no access_token' do
        do_request
        expect(response.status).to eq 401
      end

      it 'does not save object in database with no access_token' do
        expect{ do_request }.not_to change(obj_name.classify.constantize, :count)
      end
    end

    context 'with invalid token' do
      it 'returns 401 status if access_token is invalid' do
        do_request(access_token: '1234')
        expect(response.status).to eq 401
      end

      it 'does not save object in database with invalid access_token' do
        expect{ do_request(access_token: '1234') }.not_to change(obj_name.classify.constantize, :count)
      end
    end
  end

  context 'authorized' do
    context 'with invalid attributes' do
      it 'returns 422 status' do
        do_request(access_token: access_token.token, obj_name.to_sym => attributes_for("invalid_#{obj_name}".to_sym))
        expect(response.status).to eq 422
      end

      it 'does not save object in database' do
        expect{
          do_request(access_token: access_token.token, obj_name.to_sym => attributes_for("invalid_#{obj_name}".to_sym))
              }.not_to change(obj_name.classify.constantize, :count)
      end
    end

    context 'with valid attributes' do
      it 'returns 200 status code' do
        do_request(access_token: access_token.token, obj_name.to_sym => attributes_for("#{obj_name}".to_sym))
        expect(response).to be_success
      end

      it 'save question in database' do
        expect{
          do_request(access_token: access_token.token, obj_name.to_sym => attributes_for("#{obj_name}".to_sym))
              }.to change(obj_name.classify.constantize, :count).by(1)
      end
    end
  end
end