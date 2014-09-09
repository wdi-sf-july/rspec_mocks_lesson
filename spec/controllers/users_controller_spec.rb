require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  before :each do
    @user = FactoryGirl.create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  describe "Get #index" do
    it "should assign @users" do
     get :index
     expect(assigns(:users)).to eq([@user])
    end
  end
end
