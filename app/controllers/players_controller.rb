class PlayersController < ApplicationController
  before_action :authenticate_user!

  def new
    @team = Team.find_by(id: params[:team_id])
    @player = @team.players.new
  end

  def create
    @team = Team.find_by(id: params[:team_id])
    @player = @team.players.new player_params
    if @player.save
      redirect_to action: 'show', controller: 'teams', community_code: current_community.code, id: @team.id
    else
      render(:new)
    end
  end

  def edit
    @player = Player.find_by(id: params[:id])
  end

  def update
    @player = Player.find_by(id: params[:id])
    if @player.update_attributes(attributes)
      redirect_to action: 'show', controller: 'teams', community_code: current_community.code, id: @team.id
    else
      render(:edit)
    end
  end

  def destroy
    player = Player.find_by(id: params[:id])
    player.destroy
    redirect_to action: 'show', controller: 'teams', team_id: params["team_id"]
  end

  private
  def player_params
    params.require(:player).permit(:dorsal, :name, :player_template_id)
  end
end
