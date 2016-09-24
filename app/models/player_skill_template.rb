class PlayerSkillTemplate < ApplicationRecord
  belongs_to :player_template
  belongs_to :skill_template
end
