class Feat < ApplicationRecord
  belongs_to :player
  belongs_to :match

  validates :kind, :player, :match, presence: true

  after_create :assign_touchdown
  before_destroy :dissociate_touchdown

  FEATS = %i(casualty injury complention touchdown interception mpv).freeze
  POINTS = {casualty: 2, complention: 1, touchdown: 3, interception: 2, mpv: 5}
  INJURIES = [
    '11-38 Badly Hurt (No long term effect)',
    '41 Broken Ribs (Miss next game)',
    '42 Groin Strain (Miss next game)',
    '43 Gouged Eye (Miss next game)',
    '44 Broken Jaw (Miss next game)',
    '45 Fractured Arm (Miss next game)',
    '46 Fractured Leg (Miss next game)',
    '47 Smashed Hand (Miss next game)',
    '48 Pinched Nerve (Miss next game)',
    '51 Damaged Back (Niggling Injury)',
    '52 Smashed Knee (Niggling Injury)',
    '53 Smashed Hip (-1 MA)',
    '54 Smashed Ankle (-1 MA)',
    '55 Serious Concussion (-1 AV)',
    '56 Fractured Skull (-1 AV)',
    '57 Broken Neck (-1 AG)',
    '58 Smashed Collar Bone (-1 ST)',
    '61-68 DEAD (Dead!)'
  ]

  INJURIES_VALUE = {
    '11-38 Badly Hurt (No long term effect)' => :no_effect,
    '41 Broken Ribs (Miss next game)' => :miss_next_game,
    '42 Groin Strain (Miss next game)' => :miss_next_game,
    '43 Gouged Eye (Miss next game)' => :miss_next_game,
    '44 Broken Jaw (Miss next game)' => :miss_next_game,
    '45 Fractured Arm (Miss next game)' => :miss_next_game,
    '46 Fractured Leg (Miss next game)' => :miss_next_game,
    '47 Smashed Hand (Miss next game)' => :miss_next_game,
    '48 Pinched Nerve (Miss next game)' => :miss_next_game,
    '51 Damaged Back (Niggling Injury)' => :niggling_injury,
    '52 Smashed Knee (Niggling Injury)' => :niggling_injury,
    '53 Smashed Hip (-1 MA)' => :ma_injury,
    '54 Smashed Ankle (-1 MA)' => :ma_injury,
    '55 Serious Concussion (-1 AV)' => :av_injury,
    '56 Fractured Skull (-1 AV)' => :av_injury,
    '57 Broken Neck (-1 AG)' => :ag_injury,
    '58 Smashed Collar Bone (-1 ST)' => :st_injury,
    '61-68 DEAD (Dead!)' => :dead,
  }

  def assign_touchdown(number = 1)
    return unless touchdown?
    host_team? ? match.host_result += number : match.visit_result += number
    match.save!
  end

  def dissociate_touchdown(number = -1)
    assign_touchdown(number)
  end

  def assign_injury!
    return unless injury?
    case INJURIES_VALUE[injury]
    when :miss_next_game then player.miss_next_game!
    when :niggling_injury then player.add_niggling_injury
    when :ma_injury then player.remove('ma')
    when :av_injury then player.remove('av')
    when :ag_injury then player.remove('ag')
    when :st_injury then player.remove('st')
    when :dead then player.dead!
    end
  end

  def touchdown?
    kind.include? 'touchdown'
  end

  def injury?
    kind.include? 'injury'
  end

  def casualty?
    kind.include? 'casualty'
  end

  def host_team?
    player.team_id == match.host_team_id
  end

  def owner_team?(team_id)
    player.team_id == team_id
  end

  def assign_experience!
    player.add_points(POINTS[kind.to_sym])
  end
end
