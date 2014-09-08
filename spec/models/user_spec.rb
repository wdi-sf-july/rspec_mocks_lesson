require 'rails_helper'

RSpec.describe User, :type => :model do

  subject { FactoryGirl.create(:user) }

  it "should have a valid factory" do
    expect(subject).to be_valid
  end
  
  describe "#recent_posts" do
    it "to return posts in descending order" do
      post_one = FactoryGirl.create(:post)
      post_two = FactoryGirl.create(:post)
      subject.posts << [post_one, post_two]
      expect(subject.recent_posts).to eq([post_two, post_one])
    end
  end
end
