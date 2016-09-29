class PlayerTemplateSerializer < ActiveModel::Serializer
  attributes  :id,
              :quantity,
              :title,
              :cost,
              :ma,
              :st,
              :ag,
              :av,
              :normal,
              :double,
              :feeder

  attribute :team_name, key: :team

  has_many :skill_templates, through: :player_skill_templates, key: :skills
end
