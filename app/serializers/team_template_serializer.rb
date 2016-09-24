class TeamTemplateSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :description,
              :reroll_value,
              :apothecary,
              :stakes,
              :revive

  has_many :player_base
end
