class Match < ApplicationRecord
  belongs_to :season
  belongs_to :visit_team, class_name: 'Team', foreign_key: 'visit_team_id'
  belongs_to :host_team, class_name: 'Team', foreign_key: 'host_team_id'

  has_one :championship, through: :season
  has_many :feats

  DRAW = 0

  def finish!
    self.finish = true
    assign_things_from_feats!
    assign_treassury!
    save!
  end

  def winner_id
    return_winner_result if finish?
  end

  def return_winner_result
    if host_result < visit_result
      visit_team_id
    elsif host_result > visit_result
      host_team_id
    else
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

  def assign_things_from_feats!
    feats.each do |feat|
      feat.assign_experience!
      feat.assign_injury!
    end
  end

  def assign_treassury!
    host_team.add_treasury(host_team_treasury)
    visit_team.add_treasury(visit_team_treasury)
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
