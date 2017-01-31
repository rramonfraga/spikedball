class SkillTemplate < ApplicationRecord
  has_many :player_skill_templates
  has_many :player_templates, through: :player_skill_templates

  has_many :start_player_skills
  has_many :start_players, through: :start_player_skills

  validates :name, :category, :description, presence: true

  def self.by_category(category)
    where('category = ?', category).all
  end

  def players
    player_templates
  end
end
