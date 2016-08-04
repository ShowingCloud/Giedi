require 'rails_helper'

RSpec.describe UsersController do

  describe'GET#new'do
    it "assigns a new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    it "renders the :new template" do
       get :new
       expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before do
      allow_any_instance_of(ActionController::Base).to receive(:verify_rucaptcha?).and_return(true)
    end

    context "with valid attributes" do
      it "saves the new user in the database" do
        post :create, user: attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to userss#show" do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to user_path(assigns[:user])
      end
    end
  end

  describe "POST #create_by_phone" do
    before do
      allow_any_instance_of(ActionController::Base).to receive(:verify_rucaptcha?).and_return(true)
    end

    context "with valid attributes" do
      it "saves the new user in the database" do
        post :create, user: attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to userss#show" do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to user_path(assigns[:user])
      end
    end
  end

end
