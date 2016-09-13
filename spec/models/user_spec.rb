require 'rails_helper'

RSpec.describe User do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a email and a phone' do
    expect(build(:user, email: nil, phone: nil)).to_not be_valid
  end

  it 'is valid with a email but without a phone' do
    expect(build(:user, phone: nil)).to be_valid
  end

  it 'is valid without a password' do
    expect(build(:user, password: nil)).to_not be_valid
  end

  it 'is valid with a phone but without a email' do
    expect(build(:user, email: nil, phone: "18035243428")).to be_valid
  end

  it 'has confirmation_digest with a email' do
    user = create(:user)
    expect(user.confirmation_digest).not_to be_empty
  end

  # describe "ActiveModel validations" do
  #   it { is_expected.to validate_presence_of(:name) }
  #   it { is_expected.to validate_length_of(:name).is_at_most(20) }
  #   it { is_expected.to validate_presence_of(:password) }
  #   it { is_expected.to validate_length_of(:password).is_at_least(6) }
  # end

  describe "ActiveRecord associations" do
    it { expect(build(:user)).to have_one(:user_extra) }
  end

end
