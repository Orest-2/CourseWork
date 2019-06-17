require 'rails_helper'

RSpec.describe User, type: :model do
    subject{
       build(:user)
  }

  describe "validation" do
    it "is not valid without a email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a password" do
      subject.encrypted_password = nil
      expect(subject).to_not be_valid
    end
  end

  describe "associations" do
    it { should have_one(:user_param).dependent(:destroy) }
    it { should have_many(:products) }
  end

end
