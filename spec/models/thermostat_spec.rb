require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  context "valid Thermostat" do
    it "has a valid thermostat" do
      expect(FactoryGirl.build(:thermostat)).to be_valid
    end
  end
  it { should have_many(:readings) }
end
