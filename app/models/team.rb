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
  before_update :calculate_value

  FAN_FACTOR = 10000
  ASSISTANT_COACHES = 10000
  CHEERLEADERS = 10000
  APOTHECARIES = 50000

  def team
    team_template
  end

  def live_players
    @live_players ||= players.select(&:live?)
  end

  def players_by_game
    live_players.sort_by { |player| player.player_template_id }
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
    calculate_value
    save
  end

  def can_hire?
    min = team.players.map(&:cost).min
    treasury >= min
  end

  def hired_collection
    @hired_collection = []
    team.players.each do |pt|
      if group_by_title[pt.title].present?
        @hired_collection << pt if group_by_title[pt.title].count < pt.quantity
      else
        @hired_collection << pt
      end
    end
    @hired_collection
  end

  def buy_re_roll?
    treasury >= 2 * team_template.re_roll
  end

  def add_re_roll
    return false unless buy_re_roll?
    self.treasury -= 2*team_template.re_roll
    self.re_rolls += 1
    save!
  end

  def buy_apothecary?
    treasury >= APOTHECARIES && apothecaries.zero?
  end

  def add_apothecary
    return false unless buy_apothecary?
    self.treasury -= APOTHECARIES
    self.apothecaries += 1
    save!
  end

  def calculate_value
    self.value = value_of_players + value_of_assistans
  end

  private

  def group_by_title
    @group_by_title ||= live_players.group_by(&:title)
  end

  def value_of_players
    live_players.reduce(0) do |val, p|
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
