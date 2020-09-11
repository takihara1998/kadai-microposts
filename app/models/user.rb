class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts, dependent: :destroy
  
  has_many :relationships, dependent: :destroy    # belogs_to :userだから、relationships
  has_many :followings, through: :relationships, source: :follow  # 5行目と逆の関係(自分からの視点)
  
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  has_many :followers, through: :reverses_of_relationship, source: :user  # 3行目と逆の関係(相手側の視点)
  
  has_many :favorites, foreign_key: "user_id", dependent: :destroy
  has_many :likes, through: :favorites, source: :micropost

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  def like(micropost)
    # unless self == other_user
      self.favorites.find_or_create_by(micropost_id: micropost.id)  #?
  end

  def unlike(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id) #?
    favorite.destroy if favorite
  end
  
  def liking?(micropost)
    self.likes.include?(micropost)
  end

end
