class Championship < ApplicationRecord
  belongs_to :community
  has_many :team_championships
  has_many :teams, through: :team_championships
  has_many :seasons
  has_many :matches, through: :seasons

  validates :name, :kind, :community_id, presence: true

  def create_seasons
    (@teams.count - 1).times do |index|
      season = seasons.create round: index + 1
      season.create_matches(@teams)
      rotate_teams
    end
  end

  def rotate_teams
    last = @teams.pop
    @teams.insert(1, last)
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
    @teams = teams.to_a
    create_seasons
    save!
  end

  def community_code
    community_id
  end
end
