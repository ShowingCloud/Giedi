require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include Rails.application.routes.url_helpers
  describe "email_confirmation" do
    before(:all) do
      @user = create(:user)
      @token = @user.confirmation_token
      @email = UserMailer.email_confirmation(@user, @token)
    end

    it "should be set to be delivered to the email passed in" do
      expect(@email).to deliver_to(@user.email)
    end

    it "should contain the user's message in the mail body" do
      expect(@email).to have_body_text(/#{@user.name}/)
    end

    it "should contain a link to the confirmation link" do
      expect(@email).to have_body_text(edit_email_confirmation_url(@token, email: @user.email))
    end

    it "should have the correct subject" do
      expect(@email).to have_subject(/DOMELAB邮箱验证/)
    end
  end

  describe "new_email_confirmation" do
    before(:all) do
      @user = create(:user)
      @user.new_email = Faker::Internet.email
      @token = @user.confirmation_token
      @email = UserMailer.new_email_confirmation(@user, @token)
    end

    it "should be set to be delivered to the email passed in" do
      expect(@email).to deliver_to(@user.new_email)
    end

    it "should contain the user's message in the mail body" do
      expect(@email).to have_body_text(/#{@user.name}/)
    end

    it "should contain a link to the confirmation link" do
      expect(@email).to have_body_text(edit_email_confirmation_url(@token, new_email: @user.new_email))
    end

    it "should have the correct subject" do
      expect(@email).to have_subject(/DOMELAB邮箱验证/)
    end
  end

  describe "password_reset" do
    before(:all) do
      @user = create(:user)
      @user.create_reset_digest
      @reset_token = @user.reset_token
      @email = UserMailer.password_reset(@user, @reset_token)
    end

    it "should be set to be delivered to the email passed in" do
      expect(@email).to deliver_to(@user.email)
    end

    it "should contain the user's message in the mail body" do
      expect(@email).to have_body_text(/#{@user.name}/)
    end

    it "should contain a link to the confirmation link" do
      expect(@email).to have_body_text(edit_password_reset_url(@reset_token, email: @user.email))
    end

    it "should have the correct subject" do
      expect(@email).to have_subject(/DOMELAB重置密码/)
    end
  end

end
