class PlayerSkill < ApplicationRecord
  belongs_to :player
  belongs_to :skill_template
end
