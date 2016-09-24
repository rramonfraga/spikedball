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

  has_many :skill_base, through: :player_skill_base
end
