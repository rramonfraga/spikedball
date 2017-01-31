class StartPlayerSkill < ApplicationRecord
  belongs_to :start_player
  belongs_to :skill_template
end
