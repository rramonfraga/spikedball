class Season < ApplicationRecord
  belongs_to :championship
  has_many :matches

  def create_matches(teams, first_half)
    @teams = teams
    (number_of_teams/2).times do |index|
      matches.create host_team: set_host_team(index, first_half),
                     visit_team: set_visit_team(index, first_half)
    end
  end

  private

  def set_host_team(index, first_half)
    first_half.present? ? @teams[index] : @teams[(number_of_teams - 1) - index]
  end

  def set_visit_team(index, first_half)
    first_half.present? ? @teams[(number_of_teams - 1) - index] : @teams[index]
  end

  def number_of_teams
    @_number_of_teams ||= @teams.count
  end
end
