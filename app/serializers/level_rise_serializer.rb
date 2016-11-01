class LevelRiseSerializer < ActiveModel::Serializer
  attributes :id, :player_id, :first_dice, :second_dice, :title, :feat_id, :skill_id, :characteristic, :value
end
