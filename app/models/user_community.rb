class UserCommunity < ApplicationRecord
  belongs_to :user
  belongs_to :community

  def admin?
    admin == true
  end
end
