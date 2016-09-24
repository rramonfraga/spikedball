class Community < ApplicationRecord
  has_many :user_communities
  has_many :users, through: :user_communities
  has_many :championships

  validates :name, uniqueness: true

end
