class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :posts, foreign_key: :author_id, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :follows, foreign_key: :follower_id, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self


end