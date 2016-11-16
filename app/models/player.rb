class Player < ApplicationRecord
  belongs_to :team
  belongs_to :player_template

  has_many :player_skills
  has_many :skill_templates, through: :player_skills
  has_many :feats
  has_many :level_rises

  accepts_nested_attributes_for :level_rises, reject_if: proc { |attributes| attributes['characteristic'].present? && attributes['skill_id'].present? }

  validates :name, :dorsal, :player_template_id, presence: true
  validates :dorsal, numericality: {only_integer: true}
  validates_associated :level_rises

  before_create :assign_stats_from_the_template
  after_create :hired

  CATEGORIES = { G: "General", P: "Passing", A: "Agility", S: "Strength", E: "Extraordinary", M: "Mutation" }

  def player
    player_template
  end

  def skills
    skill_templates
  end

  def live?
    !dead
  end

  def add_points(points)
    self.experience += points.to_i
    new_level if new_level?
    save
  end

  def full_name
    "#{dorsal} - #{name}"
  end

  def actual_level
    case experience
    when 0..5 then "Rookie"
    when 6..15 then "Experienced"
    when 16..30 then "Veteran"
    when 31..50 then "Emerging Star"
    when 51..75 then "Star Player"
    when 76..125 then "Super-Star"
    when 126..175 then "Mega-Star"
    when 176..1000 then "Legend"
    end
  end

  def miss_next_game!
    self.miss_next_game = true
    save!
  end

  def miss_next_game?
    miss_next_game
  end

  def clean_miss_next_game!
    self.miss_next_game = false
    save!
  end

  def add_niggling_injury
    self.niggling_injury += 1
    miss_next_game!
  end

  def remove(attribute)
    case attribute
    when 'ma' then self.ma -= 1 unless ma == 1
    when 'av' then self.av -= 1 unless av == 1
    when 'ag' then self.ag -= 1 unless ag == 1
    when 'st' then self.st -= 1 unless st == 1
    end
    miss_next_game!
  end

  def dead!
    self.dead = true
    save!
  end

  def new_level?
    level != actual_level
  end

  def level_up?
    level_rises.find_index { |l| !l.assigned? }
  end

  def new_level
    self.level = actual_level
    self.level_rises.create(title: level)
  end

  def hired
    team.treasury -= cost
    team.calculate_value
    team.save
  end

  def normal_skills
    search_skills(normal_categories)
  end

  def all_skills
    @_categories ||= normal_categories + double_categories
    search_skills(@_categories)
  end

  def add_characteritic(key, improve_cost)
    return if !respond_to?(:"#{key}=")
    send(:"#{key}=", (eval("#{key}") + 1))
    self.cost += improve_cost
    save
  end

  def add_skill(id)
    skill = SkillTemplate.find(id)
    return unless skill.present?
    skills << skill
    double?(skill) ? self.cost += 30000 : self.cost += 20000
    save
  end

  def normal_categories
    @_normal_categories ||= player.normal.split("").map do |letter|
      CATEGORIES[letter.to_sym]
    end
  end

  def double_categories
    @_double_categories ||= player.double.split("").map do |letter|
      CATEGORIES[letter.to_sym]
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

  def search_skills(categories)
    skills_to_assign = categories.map { |c| SkillTemplate.by_category(c) }.flatten
    skills_to_assign - skills
  end

  def double?(skill)
    double_categories.include? skill.category
  end
end
