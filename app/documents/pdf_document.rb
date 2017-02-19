# encoding: utf-8
require 'prawn'
require 'prawn/table'

class PdfDocument < Prawn::Document
  attr_accessor :options

  def initialize(team, options = {})
    @team = team
    @players = team.live_players
    self.options = options.reverse_merge(page_size: 'A4', page_layout: :landscape)
    super(self.options)
  end

  # Generate a pdf. If a file is provided, it will be
  # evaluated as part of the current instance.
  def to_pdf(file = nil)
    #prepare_fonts
    header
    table_players
    footer
    instance_eval(read(file), file) if file
    render
  end

  def filename
    "#{@team.name.downcase}.pdf"
  end

  def header
    text "#{@team.name} - #{@team.team.name} - #{@team.user.name}", size: 20, style: :bold
    image Rails.root.join('public/images/logo-spiked-ball.png'), width: 100, at: [bounds.right - 113, bounds.top - 0]

    font_size 14
    text "Treasury: #{@team.treasury} - Value: #{@team.value}"
  end

  def table_players
    # Players
    font_size 10
    data = [player_head]
    16.times.each do |index|
      data << [bold(index + 1)] + add_players(@players[index])
    end
    table(data, width: 770, cell_style: { inline_format: true }, column_widths: column_widths) do |table|
      table.row(0).background_color = "65C5E4"
      table.column(0).background_color = "65C5E4"
      table.row(0).text_color = "ECF0F1"
      table.column(0).text_color = "ECF0F1"
    end
  end

  def footer
    table(extras, cell_style: { inline_format: true }, column_widths: [130, 50]) do |table|
      table.column(1..-1).each{|c| c.background_color = "65C5E4" }
      table.column(1..-1).each{|c| c.background_color = "ECF0F1" }
    end
  end

  def player_head
    ["", bold("Dorsal"), bold("Name"), bold("Title"), bold("MA"), bold("ST"), bold("AG"), bold("AV"), bold("Cost"), bold("Skills"), bold("Niggly"), bold("Exp")]
  end

  def add_players(player)
    return ["", "", "", "", "", "", "", "", "", "", "",] unless player.present?
    return injured_player(player) if player.miss_next_game?
    player_stats(player)
  end

  def injured_player(player)
    [
      strike(player.dorsal),
      strike(player.name),
      strike(player.title),
      strike(player.ma),
      strike(player.st),
      strike(player.ag),
      strike(player.av),
      strike(player.cost),
      strike(player.full_skills),
      strike(player.niggling_injury),
      strike(player.experience)
    ]
  end

  def player_stats(player)
    [
      player.dorsal,
      player.name,
      player.title,
      player.ma,
      player.st,
      player.ag,
      player.av,
      player.cost,
      player.full_skills,
      player.niggling_injury,
      player.experience
    ]
  end

  def column_widths
    [30, 50, 110, 90, 40, 40, 40, 40, 70, 160, 50, 50]
  end

  def extras
    [
      ["Re-Rolls", @team.re_rolls],
      ["Fan Factor", @team.fan_factor],
      ["Assistant Coaches", @team.assistant_coaches],
      [ "Cheerleaders", @team.cheerleaders],
      ["Apothecaries", @team.apothecaries]
    ]
  end

  def strike(value)
    "<i>#{value}</i>"
  end

  def bold(value)
    "<b>#{value}</b>"
  end
end
