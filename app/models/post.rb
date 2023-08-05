class Post < ApplicationRecord
    validates :title, presence: true
    validates :topic, presence: true
    validates :text, presence: true
    validates :published_at, presence: true
    validates :author, presence: true

    belongs_to :author, class_name: 'User', foreign_key: :author_id
    has_many :likes, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy, counter_cache: true
  end
  