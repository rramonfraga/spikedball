class PlayerTemplate < ApplicationRecord
  belongs_to :team_template

  has_many :player_skill_templates
  has_many :skill_templates, through: :player_skill_templates

  validates :quantity, :title, :cost, :ma, :st, :ag, :av, :normal, :double, presence: true

  def skills
    skill_templates
  end

  def team_name
    team_template.name
  end
end
