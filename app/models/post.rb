class Post < ApplicationRecord
    validates :title, presence: true
    validates :topic, presence: true
    validates :text, presence: true
    validates :published_at, presence: true
    validates :author, presence: true
  end
  