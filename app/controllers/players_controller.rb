class PlayersController < ApplicationController
  before_action :authenticate_user!

  def destroy
    player = Player.find_by(id: params[:id])
    player.destroy
    redirect_to action: 'show', controller: 'teams', team_id: params["team_id"]
  end

end
