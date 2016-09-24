class TeamTemplate < ApplicationRecord
  has_many :player_templates

  validates :name, :description, :re_roll, presence: true
end
