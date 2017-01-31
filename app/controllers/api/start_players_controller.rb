class Api::StartPlayersController < ApplicationController
  def index
    teams = StartPlayer.all
    render json: teams, each_serializer: StartPlayerSerializer
  end

  def show
    team = StartPlayer.find_by id: params[:id]
    render json: team, serializer: StartPlayerSerializer
  end
end
