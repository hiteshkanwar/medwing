require 'rails_helper'

RSpec.describe Reading, type: :model do
  context "valid Reading" do
    it "has a valid reading" do
      expect(FactoryGirl.build(:reading)).to be_valid
    end
  end
  it { is_expected.to validate_presence_of(:temperature) }
  it { is_expected.to validate_presence_of(:humidity) }
  it { is_expected.to validate_presence_of(:battery_charge) }
  it { should belong_to(:thermostat) }
  
end
