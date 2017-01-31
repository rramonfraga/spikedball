class StartPlayer < ApplicationRecord
  has_many :start_player_skills
  has_many :skill_templates, through: :start_player_skills

  has_many :start_player_teams
  has_many :team_templates, through: :start_player_teams

  def team_names
    team_templates.map(&:name)
  end

  def skill_names
    skill_templates.map(&:name)
  end
end
