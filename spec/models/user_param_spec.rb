require 'rails_helper'  

RSpec.describe UserParam, type: :model do
  let!(:user){create(:user)}

  subject{
     build(:user_param, user: user)
  }

  context "validation" do
    
    it "should not be valid without firstname" do
       subject.first_name = nil
       expect(subject).to_not be_valid
    end
    
  end

  context "association" do
    it { should belong_to(:user).with_foreign_key('user_id') }
  end

end
