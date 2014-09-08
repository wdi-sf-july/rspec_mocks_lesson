require 'rails_helper'

RSpec.describe PostsController, :type => :controller do
  describe "Get index" do
    it "should assign @posts" do   
      user_class = class_double("User")
      user = instance_double("User")
      post_class = class_double("Post")
      allow(user).to receive(:posts).and_return([post_class])
      allow(User).to receive(:foo).and_return(user)
      expect(User).to receive(:find_by_id).and_return(user)
      session["user_id"] = 1
      get :index, {user_id: 1}
      expect(assigns(:user)).to eq(user) 
    end

  end

end
