class LevelRise < ApplicationRecord
  belongs_to :player
  belongs_to :feat
  belongs_to :skill

end
