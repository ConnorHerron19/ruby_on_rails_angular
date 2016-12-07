require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe Api::BookingsController, type: :controller do
  describe "POST #create" do
    it "returns http success" do
      create_booking
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    it "returns a Returns a valid response for taxi unavailability" do
      create_booking
      message = { message: 'We do not have any available taxis. Try again in a few seconds' }
      expect(response.body).to eq(message.to_json)
    end

    it "returns a Returns a valid response for successful taxi request" do
      5.times {FactoryGirl.create(:driver)}
      create_booking
      message = { message: 'Searching for available taxis......' }
      expect(response.body).to eq(message.to_json)
    end
  end

  describe "POST #accept" do
    it "returns http success" do
      accept_response
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    it "returns an appropraite response for valid params" do

    end

    it "returns error message for invalid params" do
      
    end
  end

end
