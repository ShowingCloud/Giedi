require 'rails_helper'

describe UserMailer do
  describe 'email_confirmation' do
    before(:all) do
      @user = create(:user)
      @token = @user.confirmation_token
      @mail = described_class.email_confirmation(@user, @token)
    end
    context 'headers' do
      it 'renders the subject' do
        expect(@mail.subject).to eq "DOMELAB邮箱验证"
      end

      it 'sends to the right email' do
        expect(@mail.to).to eq [@user.email]
      end

      it 'renders the from email' do
        expect(@mail.from).to eq ['service@mail.robodou.cn']
      end
    end
    context 'html_part' do
      it "includes the correct url with the user's token" do
        expect(@mail.html_part.body.to_s).to include edit_email_confirmation_url(@token, email: @user.email)
      end

      it 'includes the username' do
        expect(@mail.html_part.body.to_s).to include @user.name
      end
    end

    context 'text_part' do
      it "includes the correct url with the user's token" do
        expect(@mail.text_part.body.to_s).to include edit_email_confirmation_url(@token, email: @user.email)
      end

      it 'includes the username' do
        expect(@mail.text_part.body.to_s).to include @user.name
      end
    end
  end

  describe 'new_email_confirmation' do
    before(:all) do
      @user = create(:user)
      @user.new_email = Faker::Internet.email
      @token = @user.confirmation_token
      @mail = described_class.new_email_confirmation(@user, @token)
    end
    context 'headers' do
      it 'renders the subject' do
        expect(@mail.subject).to eq "DOMELAB邮箱验证"
      end

      it 'sends to the right email' do
        expect(@mail.to).to eq [@user.new_email]
      end

      it 'renders the from email' do
        expect(@mail.from).to eq ['service@mail.robodou.cn']
      end
    end
    context 'html_part' do

      it "includes the correct url with the user's token" do
        expect(@mail.html_part.body.decoded).to include edit_email_confirmation_url(@token,new_email: @user.new_email,email:@user.email).gsub("&","&amp;")
      end

      it 'includes the username' do
        expect(@mail.html_part.body.decoded).to include @user.name
      end
    end

    context 'text_part' do

      it "includes the correct url with the user's token" do
        expect(@mail.text_part.body.decoded).to include edit_email_confirmation_url(@token,new_email: @user.new_email,email:@user.email)
      end

      it 'includes the username' do
        expect(@mail.text_part.body.decoded).to include @user.name
      end
    end
  end

  describe 'password_reset' do
    before(:all) do
      @user = create(:user)
      @user.create_reset_digest
      @reset_token = @user.reset_token
      @mail = described_class.password_reset(@user, @reset_token)
    end
    context 'headers' do
      it 'renders the subject' do
        expect(@mail.subject).to eq "DOMELAB重置密码"
      end

      it 'sends to the right email' do
        expect(@mail.to).to eq [@user.email]
      end

      it 'renders the from email' do
        expect(@mail.from).to eq ['service@mail.robodou.cn']
      end
    end
    context 'html_part' do
      it "includes the correct url with the user's token" do
        expect(@mail.html_part.body.to_s).to include edit_password_reset_url(@reset_token, email: @user.email)
      end

      it 'includes the username' do
        expect(@mail.html_part.body.to_s).to include @user.name
      end
    end

    context 'text_part' do
      it "includes the correct url with the user's token" do
        expect(@mail.text_part.body.to_s).to include edit_password_reset_url(@reset_token, email: @user.email)
      end

      it 'includes the username' do
        expect(@mail.text_part.body.to_s).to include @user.name
      end
    end
  end
end
