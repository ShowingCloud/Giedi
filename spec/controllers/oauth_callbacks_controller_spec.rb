require 'rails_helper'
RSpec.describe OauthCallbacksController, type: :controller do
  describe "#create" do
    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
    end

    describe "when signed_in" do

      before(:each) do
        @user = create(:user)
        allow(controller).to receive(:current_user) { CASino::User.create(authenticator:"test",username: @user.name, extra_attributes: { guid: @user.id  }) }
        allow(controller).to receive(:signed_in?) {true}
      end

      describe "when bound" do
        before do
          identity=Identity.find_for_oauth(OmniAuth.config.mock_auth[:github])
          identity.user = @user
          identity.save
        end

        it "redirect_to profile page" do
          post :create, provider: :github
          expect(response).to redirect_to '/profile'
        end

        it "show already bound message" do
          post :create, provider: :github
          expect(flash[:notice]).to eq "已经绑定过本帐号"
        end
      end

      describe "when unbound" do
        it "redirect_to profile page" do
          post :create, provider: :github
          expect(response).to redirect_to '/profile'
        end

        it "show bound successed message" do
          post :create, provider: :github
          expect(flash[:notice]).to eq "绑定成功"
        end
      end
    end

    describe "when unsigned_in" do
      describe "when user present" do
        before do
          @user = create(:user)
          identity=Identity.find_for_oauth(OmniAuth.config.mock_auth[:github])
          identity.user = @user
          identity.save
        end

        it "sign in the user" do
          post :create, provider: :github
          expect(response).to redirect_to '/sessions'
        end
      end
      describe "when user not present" do
        it "redirect_to login page" do
          post :create, provider: :github
          expect(response).to redirect_to '/login'
        end
      end
    end
  end
end
