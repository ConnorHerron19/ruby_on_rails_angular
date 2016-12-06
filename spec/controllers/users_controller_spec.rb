require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe Api::UsersController, type: :controller do
  it "has access to the helper method (authenticate_user) defined in the module" do
    user = FactoryGirl.create(:user)
    expect(authenticate_user(user.token)).to eq(user)
  end

  it "has access to the helper method (returned_user) defined in the module" do
    user = FactoryGirl.create(:user)
    expect(returned_user(user)).to eq(returned_user(user))
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    it "renders a message for a user who is not logged in" do
      session[:current_user_id] = nil
      get :index
      welcome_message = {message: "Welcome to STRS-TAXI, please login to continue"}
      expect(response.body).to eq welcome_message.to_json
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end
  end

  describe "POST #login" do
    it "returns http success" do
      login
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    it "returns a valid user details for valid login" do
      login
      user = User.find_by(id: session[:current_user_id])
      returned_user = returned_user(user)
      expect(response.body).to eq(returned_user.to_json)
    end

    it "returns a an error message for non existing email/password combination" do
      post :login, user: { email: "anyemail@email.com", password: "user_password"}
      error_message = { error: 'Inavalid email and/or passowrd' }
      expect(response.body).to eq(error_message.to_json)
    end

    it "creates a session for the logged in user" do
      login
      expect(session[:current_user_id]).not_to eq(nil)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      user = FactoryGirl.create(:user)
      get :show, id: user.token
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    it "returns a valid user for valid token" do
      user = FactoryGirl.create(:user)
      get :show, id: user.token
      returned_user = returned_user(user)
      expect(response.body).to eq(returned_user.to_json)
    end
  end

  describe "GET #logout" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    it "logs out the current_user" do
      expect(session[:current_user_id]).to eq(nil)
    end
  end

  describe "POST #create" do
    it "returns http success" do
      user_attributes = FactoryGirl.attributes_for(:user)
      post :create, { user: user_attributes }
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    it "returns a valid user details for valid login" do
      user_attributes = FactoryGirl.attributes_for(:user)
      post :create, { user: user_attributes }
      response_message = {status: "Your registration was successfully, sign in to use our service"}
      expect(response.body).to eq response_message.to_json
    end

    it "returns an error message for incomplete parameters" do
      post :create, user: { email: "anyemail@email.com", password: "user_password", user_type: "Blaaaaah"}
      error_message = {error: "We could not create an account for you.Please try again"}
      expect(response.body).to eq error_message.to_json
    end
  end

  describe "POST #status" do
    it "returns http success" do
      user = FactoryGirl.create(:user, user_type: "Driver")
      driver = FactoryGirl.create(:driver, user_id: user.id)
      post :status, {user: {"token": user.token}, driver: {"status": "Available"}}
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    it "updates the drivers status to the given status update" do
      user = FactoryGirl.create(:user, user_type: "Driver")
      driver = FactoryGirl.create(:driver, user_id: user.id)
      post :status, {user: {"token": user.token}, driver: {"status": "Available"}}
      expect(user.driver.status).to eq "Available"
    end

    it "Gives a successfully response for valid driver" do
      user = FactoryGirl.create(:user, user_type: "Driver")
      driver = FactoryGirl.create(:driver, user_id: user.id)
      post :status, {user: {"token": user.token}, driver: {"status": "Available"}}
      response_message = {status: "Your status has been successfully updated"}
      expect(response.body).to eq response_message.to_json
    end

    it "Throws an error message for someone who isn't a driver" do
      user = FactoryGirl.create(:user)
      post :status, {user: {"token": user.token}, driver: {"status": "Available"}}
      response_message = {error: "You are not authorized to perform this action"}
      expect(response.body).to eq response_message.to_json
    end
  end

end
