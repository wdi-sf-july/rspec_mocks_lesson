class User < ActiveRecord::Base

  has_secure_password
  
  has_many :posts
  
  def recent_posts
    posts.order("created_at DESC").limit(5)
  end
end
