class Team < ApplicationRecord
  belongs_to :user
  belongs_to :team_template

  has_many :players

  has_many :team_championships
  has_many :championships, through: :team_championships
  has_many :hosting, class_name: 'Match', foreign_key: 'host_team_id'
  has_many :visiting, class_name: 'Match', foreign_key: 'visit_team_id'

  accepts_nested_attributes_for :players, reject_if: proc { |attributes| attributes['dorsal'].blank? && attributes['name'].blank? }

  validates :name, :team_template_id, presence: true
  validates :treasury, numericality: { greater_than_or_equal_to: 0 }

  after_create :set_value!

  FAN_FACTOR = 10000
  ASSISTANT_COACHES = 10000
  CHEERLEADERS = 10000
  APOTHECARIES = 50000

  def team
    team_template
  end

  def calculate_points(championship)
    championship.matches.reduce(0) do |points, match|
      if match.winner?(self)
        points += 3
      elsif match.draw?(self)
        points += 1
      else
        points += 0
      end
    end
  end

  def calculate_touchdonws(championship)
    championship.matches.reduce(0) do |touchdonws, match|
      touchdonws + match.touchdonws(self)
    end
  end

  def joined?
    active_championship.present?
  end

  def active_championship
    championships.find{ |championship| !championship.finish? }
  end

  def add_treasury(treasury)
    self.treasury += treasury
    save
  end

  def add_fan_factor(fans, winner)
    if winner == self || winner == Match::DRAW
      self.fan_factor += 1 if fans > fan_factor
    elsif winner != self || winner == Match::DRAW
      self.fan_factor -= 1 if fans < fan_factor
    end
    save
  end

  def set_value!
    calculate_value!
  end

  def can_hire?
    min = team.players.map(&:cost).min
    treasury >= min
  end

  private
  def calculate_value!
    self.value = value_of_players + value_of_assistans
    save!
  end

  def value_of_players
    players.reduce(0) do |val, p|
      p.miss_next_game? ? val : val + p.cost
    end
  end

  def value_of_assistans
    re_rolls * team_template.re_roll +
      fan_factor * FAN_FACTOR +
      assistant_coaches * ASSISTANT_COACHES +
      cheerleaders * CHEERLEADERS +
      apothecaries * APOTHECARIES
  end
end
