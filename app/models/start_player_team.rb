class StartPlayerTeam < ApplicationRecord
  belongs_to :start_player
  belongs_to :team_template
end
