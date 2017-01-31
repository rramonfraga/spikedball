class StartPlayerSerializer < ActiveModel::Serializer
  attributes :id, :name, :cost, :ma, :st, :ag, :av, :feeder
  attribute :team_names, key: :teams
  attribute :skill_names, key: :skills
end
