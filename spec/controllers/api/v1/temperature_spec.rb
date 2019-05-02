require 'rails_helper'
require "factory_girl"

describe 'Temperature API', type: :request do

  before do
    @thermostat = FactoryGirl.create(:thermostat)
    @reading = FactoryGirl.create(:reading)
    @reading1 = FactoryGirl.create(:reading)
  end

  it "without token through 404 error  " do
    post "/api/v1/temperature/reading", :params => {humidity: 10, temperature: 20,  battery_charge: 100 }
    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(401)
  end

  it "#post request to create reading with token" do
    headers = {
      "Household-Token" => @thermostat.household_token # token
    }
    post "/api/v1/temperature/reading", :params => {humidity: 10, temperature: 20,  battery_charge: 100 }, :headers => headers
    expect(response.content_type).to eq("application/json")
    expect(@reading.number).to eq(1)
    expect(response).to have_http_status(200)
  end

  it "get request for reading with id" do
    headers = {
      "Household-Token" => @thermostat.household_token # token
    }
    get "/api/v1/temperature/:id/reading", :headers => headers
    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(200)
  end

  it "get request for reading stat" do
    headers = {
      "Household-Token" => @thermostat.household_token # token
    }
    get "/api/v1/temperature/stats", :headers => headers 
    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(200)
  end

end