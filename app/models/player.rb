class Player < ApplicationRecord
  belongs_to :team
  belongs_to :player_template

  has_many :player_skills
  has_many :skill_templates, through: :player_skills
  has_many :feats

  validates :name, :dorsal, :player_template_id, presence: true
  validates :dorsal, numericality: {only_integer: true}

  before_create :assign_stats_from_the_template

  CATEGORIES = { g: "General", p: "Passing", a: "Agility", s: "Strength", e: "Extraordinary", m: "Mutation" }

  def add_points(points)
    self.experience += points
    new_level if new_level?
    save
  end

  def actual_level
    case experience
    when 6..15 then "Experienced"
    when 16..30 then "Veteran"
    when 31..50 then "Emerging Star"
    when 51..75 then "Star Player"
    when 76..125 then "Super-Star"
    when 126..175 then "Mega-Star"
    when 176..1000 then "Legend"
    end
  end

  def new_level?
    level != actual_level
  end

  def new_level
    self.level = actual_level
    self.dice_roll = Dice.two_six
    self.level_up = true
  end


  def search_normal_skills
    letters = player.normal.split("")
    letters.map do |letter|
      category = CATEGORIES[letter.to_sym]
      skills << SkillTemplate.by_category( category )
    end
  end

  def search_double_skills
    letters = player.double.split("")
    letters.map do |letter|
      category = CATEGORIES[letter.to_sym]
      skills << SkillTemplate.by_category( category )
    end
  end

  private
  def assign_stats_from_the_template
    self.cost = player_template.cost
    self.title = player_template.title
    self.ma = player_template.ma
    self.st = player_template.st
    self.ag = player_template.ag
    self.av = player_template.av
    self.skill_templates = player_template.skill_templates if player_template.skill_templates
  end
end
