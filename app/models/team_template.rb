class TeamTemplate < ApplicationRecord
  has_many :player_templates

  has_many :start_player_teams
  has_many :start_players, through: :start_player_teams

  validates :name, :description, :re_roll, presence: true

  def players
    player_templates
  end
end
