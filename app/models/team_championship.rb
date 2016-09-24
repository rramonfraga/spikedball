class TeamChampionship < ApplicationRecord
  belongs_to :championship
  belongs_to :team
end
