require 'rails_helper'

RSpec.describe PhoneVerificationsController, type: :controller do
  describe 'POST #create' do
      before do
          allow_any_instance_of(ActionController::Base).to receive(:verify_rucaptcha?).and_return(true)
      end

      context 'with valid attributes' do
          it 'saves the new phone_verification in the database' do
              expect {
                post :create, phone: "18035243428"
              }.to change(PhoneVerification, :count).by(1)
          end

          it 'get success response' do
              post :create, phone: "18035243428"
              expect(response).to be_success
          end
      end

      context 'with invalid attributes' do
          it 'does not save the new phone_verification in the database' do
              expect do
                  post :create, phone: Faker::Number.number(9)
              end.to_not change(User, :count)
          end
          it 'get http_status 422' do
              post :create, phone: Faker::Number.number(9)
              expect(response).to have_http_status(422)
          end
      end
  end
end
