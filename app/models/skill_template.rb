class SkillTemplate < ApplicationRecord
  has_many :player_skill_templates
  has_many :player_templates, through: :player_skill_templates

  validates :name, :category, :description, presence: true

  def self.by_category(category)
    where('category = ?', category).all
  end

  def players
    player_templates
  end
end
