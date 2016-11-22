class PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_player, only: [:show, :edit, :update, :destroy]


  def new
    @team = Team.find_by(id: params[:team_id])
    @player = @team.players.new
  end

  def create
    @team = Team.find_by(id: params[:team_id])
    @player = @team.players.new player_params
    return go_to_team(@team.id) if @player.save
    render(:new)
  end

  def show
  end

  def edit
  end

  def update
    @player.update_attributes(player_params)
    return go_to_team(@player.team_id) if @player.save
    render(:edit)
  end

  def destroy
    @player.destroy
    go_to_team(@player.team_id)
  end

  private
  def player_params
    params.require(:player).permit(:dorsal, :name, :player_template_id, :ma, :st, :ag, :av, :cost, level_rises_attributes: [:id, :characteristic, :skill_id])
  end

  def go_to_team(team_id)
    redirect_to action: 'show', controller: 'teams', community_code: current_community.code, id: team_id
  end

  def set_player
    @player = Player.find_by(id: params[:id])
  end
end
