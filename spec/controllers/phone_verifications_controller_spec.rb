require 'rails_helper'

RSpec.describe PhoneVerificationsController, type: :controller do
  describe 'POST #create' do
      before do
          allow_any_instance_of(ActionController::Base).to receive(:verify_rucaptcha?).and_return(true)
          Rails.cache.clear
      end

      context 'with valid attributes' do
          it 'get success response' do
              post :create, phone: "18035243428"
              expect(response).to be_success
          end
      end

      context 'with invalid attributes' do
          it 'get http_status 422' do
              post :create, phone: Faker::Number.number(9)
              expect(response).to have_http_status(422)
          end
      end
  end
end
