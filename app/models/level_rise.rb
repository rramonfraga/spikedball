class LevelRise < ApplicationRecord
  MANY_OPTION_ERROR = 'Just can gain one thin'.freeze
  belongs_to :player
  belongs_to :feat
  belongs_to :skill

  before_create :roll_dices
  before_update :assign
  validate :many_option_present?, on: :update

  def double?
    first_dice == second_dice
  end

  def st?
    (first_dice + second_dice) == 12
  end

  def ag?
    (first_dice + second_dice) == 11
  end

  def mo_or_av?
    (first_dice + second_dice) == 10
  end

  def assign
    assing_characteristic if characteristic.present?
    assing_skill if skill_id.present?
    player.team.set_value!
  end

  def assigned?
    characteristic.present? ^ skill_id.present?
  end

  def many_option_present?
    if characteristic.present? && skill_id.present?
      errors.add MANY_OPTION_ERROR
    end
  end

  def skill_name
    @skill_name ||= SkillTemplate.find(skill_id).name
  end

  private

  def assing_characteristic
    case characteristic
    when '+1 ST' then player.add_characteritic('st', 50000)
    when '+1 AG' then player.add_characteritic('ag', 40000)
    when '+1 MA' then player.add_characteritic('ma', 30000)
    when '+1 AV' then player.add_characteritic('av', 30000)
    end
  end

  def assing_skill
    player.add_skill(skill_id)
  end

  def roll_dices
    self.first_dice = rand(6) + 1
    self.second_dice = rand(6) + 1
  end
end
