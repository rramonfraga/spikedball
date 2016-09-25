class TeamTemplateSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :description,
              :re_roll,
              :apothecary,
              :stakes,
              :revive


  has_many :player_templates, key: :players
end
