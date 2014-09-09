require 'rails_helper'

RSpec.describe PostsController, :type => :controller do
  describe "Get index" do
    before (:each) do
      @user = mock_model("User")
      @post = mock_model("Post")
    end

    describe "for a particular user" do
      it "should assign @user and @posts" do   
        expect(@user).to receive(:posts).and_return([@post])
        expect(User).to receive(:find_by_id).and_return(@user).twice()
        session["user_id"] = 1
        get :index, { user_id: 1}
        expect(assigns(:user)).to be(@user)
        expect(assigns(:posts)).to eq([@post])
      end
    end

  end

end
