class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_communities
  has_many :communities, through: :user_communities
  has_many :teams

  def free_teams
    teams.map { |team| team if !team.joined? }.compact
  end

  def championships
    teams.flat_map { |team| team.championships }.compact
  end

  def admin?(community)
    user_communities.find { |p| p.community == community }.admin? if user_communities.present?
  end

  def owner_team?(team)
    id == team.user_id
  end

  def can_edit?(team, community)
    owner_team?(team) || admin?(community)
  end

  def can_level_up?(player, community)
    owner_team?(player.team) || admin?(community)
  end

  def can_fire?(player, community)
    owner_team?(player.team) || admin?(community)
  end
end
