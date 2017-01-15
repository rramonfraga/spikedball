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
      [
        calculate_points_by(team),
        calculate_of('touchdonw', team),
        calculate_of('casualties', team),
        calculate_of('complention', team),
        calculate_of('interception', team)
      ]
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

  def calculate_of(type, team)
    matches = fetch_matches_for(team)
    feth_feats_by(type, matches, team.id).count
  end

  def matches_played_by(team)
    fetch_matches_for(team).select(&:finish?).count
  end

  def calculate_points_by(team)
    fetch_matches_for(team).reduce(0) do |points, match|
      if match.winner?(team)
        points += 3
      elsif match.draw?(team)
        points += 1
      else
        points += 0
      end
    end
  end

  private

  def fetch_matches_for(team)
    matches.select{ |match| match.include_team?(team.id) }
  end

  def feth_feats_by(type, matches, team_id)
    matches.map do |match|
      match.feats.select{ |feat| feat.kind == type && feat.owner_team?(team_id) }
    end.flatten
  end

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
