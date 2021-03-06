class Match < ApplicationRecord
  belongs_to :season
  belongs_to :visit_team, class_name: 'Team', foreign_key: 'visit_team_id'
  belongs_to :host_team, class_name: 'Team', foreign_key: 'host_team_id'

  has_one :championship, through: :season
  has_many :feats

  DRAW = 0
  PLAYED = 1
  NOT_PLAYED = 0
  AMOUNT = [10000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000]

  def finish!
    self.finish = true
    clean_injured_players!
    assign_things_from_feats!
    assign_benefits_to_teams!
    save!
  end

  def winner?(team)
    winner == team if finish?
  end

  def draw?(team)
    return unless team == host_team || team == visit_team
    winner == DRAW if finish?
  end

  def winner
    if host_result < visit_result
      visit_team
    elsif host_result > visit_result
      host_team
    else host_result == visit_result
      DRAW
    end
  end

  def touchdonws(team)
    if host_team_id == team.id
      host_result
    elsif visit_team_id == team.id
      visit_result
    else
      DRAW
    end
  end

  def include_team?(team_id)
    host_team_id == team_id || visit_team_id == team_id
  end

  def host_feats
    feats.select { |feat| feat.host_team? if feat.id }
  end

  def visit_feats
    feats.select { |feat| !feat.host_team? if feat.id }
  end

  def assign_things_from_feats!
    feats.each do |feat|
      feat.assign_experience!
      feat.assign_injury!
    end
  end

  def assign_benefits_to_teams!
    host_team.add_benefits(host_team_treasury, host_team_fan_factor, winner)
    visit_team.add_benefits(visit_team_treasury, visit_team_fan_factor, winner)
  end

  def clean_injured_players!
    host_team.players.each { |player| player.clean_miss_next_game! }
    visit_team.players.each { |player| player.clean_miss_next_game! }
  end

  def title
    host_team.name + ' VS ' + visit_team.name
  end

  def title_result
    host_result.to_s + " - #{title} - " +  visit_result.to_s
  end

  def can_validate?(user)
    user.owner_team?(host_team)||
      user.owner_team?(visit_team) ||
      user.admin?(championship.community)
  end
end
