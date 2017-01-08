class Championship < ApplicationRecord
  belongs_to :community
  has_many :team_championships
  has_many :teams, through: :team_championships
  has_many :seasons
  has_many :matches, through: :seasons

  validates :name, :kind, :community_id, presence: true

  def direct_first_half
    create_seasons(1, true)
  end

  def direct_second_half
    create_seasons(number_of_teams, false)
  end

  def clasification
    teams.sort_by do |team|
      [team.calculate_points(self), team.calculate_touchdonws(self)]
    end.reverse
  end

  def join!(team)
    self.teams << team
    save!
  end

  def start!
    self.start = true
    direct_first_half
    save!
  end

  def community_code
    community_id
  end

  private

  def create_seasons(round, first_half)
    (number_of_teams - 1).times do |index|
      season = seasons.create round: index + round
      season.create_matches(ordered_teams, first_half)
      rotate_teams
    end
  end

  def rotate_teams
    last = ordered_teams.pop
    ordered_teams.insert(1, last)
  end

  def ordered_teams
    @_ordered_teams ||= teams.sort_by(&:id)
  end

  def number_of_teams
    @_number_of_teams ||= ordered_teams.count
  end
end
