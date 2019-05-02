FactoryGirl.define do

   factory :thermostat do |f|
    f.household_token 'sfghgdgjhghjgdhj'
    f.location 'indore'
    after(:create) do |thermostat|
      create_list(:reading, 3, thermostat: thermostat)
    end
  end


  factory :reading do |f|
  	f.association :thermostat
    f.temperature 20
    f.humidity 20
    f.battery_charge 100
    f.number 1
  end


end