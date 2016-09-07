require 'rails_helper'
WebMock.stub_request(:any, "api.submail.cn")
RSpec.describe UsersController do
  describe'guest access' do
    describe'GET#new' do
      it 'assigns a new User to @user' do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
      it 'renders the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe'GET#new_by_phone' do
      it 'assigns a new User to @user' do
        get :new_by_phone
        expect(assigns(:user)).to be_a_new(User)
      end
      it 'renders the :new_by_phone template' do
        get :new_by_phone
        expect(response).to render_template :new_by_phone
      end
    end

    describe 'POST #create' do
      before do
        allow_any_instance_of(ActionController::Base).to receive(:verify_rucaptcha?).and_return(true)
      end

      context 'with valid attributes' do
        it 'saves the new user in the database' do
          expect do
            post :create, user: attributes_for(:user)
          end.to change(User, :count).by(1)
        end

        it "should deliver the signup email" do

          post :create, user: {"email" => "email@example.com", "name" => "Jimmy Bean", "password" =>Faker::Internet.password }
          expect(UserMailer).to(receive(:email_confirmation).with(assigns(:user),assigns(:user).confirmation_token))
      end

        it 'redirects to sessions' do
          post :create, user: attributes_for(:user)
          expect(response).to render_template "users/before_confirmed"
        end
      end

      context 'with invalid attributes' do
        it 'does not save the new user in the database' do
          expect do
            post :create, user: attributes_for(:invalid_user)
          end.to_not change(User, :count)
        end
        it 're-renders the :new template' do
          post :create, user: attributes_for(:invalid_user)
          expect(response).to render_template :new
        end
      end
    end

    describe 'POST #create_by_phone' do
      before :each do
        phone_verification = create(:phone_verification)
        @pin = phone_verification.pin
      end

      context 'with valid attributes' do
        it 'saves the new user in the database' do
          expect do
            post :create_by_phone, user: attributes_for(:phone_user), pin: @pin
          end.to change(User, :count).by(1)
        end

        it 'redirects to sessions' do
          post :create_by_phone, user: attributes_for(:phone_user), pin: @pin
          expect(response).to redirect_to '/sessions'
        end
      end

      context 'with invalid attributes' do
        it 'does not save the new user in the database' do
          expect do
            post :create_by_phone, user: attributes_for(:phone_user, name: nil), pin: @pin
          end.to_not change(User, :count)
        end
        it 're-renders the :new_by_phone template' do
          post :create_by_phone, user: attributes_for(:phone_user, name: nil), pin: @pin
          expect(response).to render_template :new_by_phone
        end
      end
    end
  end

  describe 'users access' do
    before :each do
      user = create(:user)
      session[:user_id] = user.id
    end

    describe 'GET #profile' do
      it 'renders the :profile template' do
        get :profile
        expect(response).to render_template :profile
      end
    end

    describe 'GET #add_email' do
      it 'renders the :add_email template' do
        get :add_email
        expect(response).to render_template :add_email
      end
    end

    describe 'GET #add_phone' do
      it 'renders the :add_phone template' do
        get :add_phone
        expect(response).to render_template :add_phone
      end
    end

    describe 'GET #edit_password' do
      it 'renders the :edit_password template' do
        get :edit_password
        expect(response).to render_template :edit_password
      end
    end

    describe 'GET #edit_avatar' do
      it 'renders the :edit_avatar template' do
        get :edit_avatar
        expect(response).to render_template :edit_avatar
      end
    end

    describe 'PATCH #update' do
      before :each do
        @user = create(:user,password:"HtYjFp94B")
        session[:user_id] = @user.id
      end

      context "update password" do
        context "with right old password" do
          it "change @user's password" do
            patch :update,id:@user, user:{current_password:"HtYjFp94B",password:"Nk7fWxY18"}
            @user.reload
            expect(@user.reload.authenticate("Nk7fWxY18").id).to eq(@user.id)
          end
        end

        context "with wrong old password" do
          it "does not change @user's password" do
            patch :update,id:@user, user:{current_password:"tYjFp94B",password:"Nk7fWxY18"}
            @user.reload
            expect(@user.reload.authenticate("Nk7fWxY18")).to be false
          end
        end
      end

      context "update name" do
          it "change @user's name" do
            name = Faker::Internet.user_name
            patch :update,id:@user, user:{name:name}
            @user.reload
            expect(@user.name).to eq(name)
          end
      end

    end
  end
end
