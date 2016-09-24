class Api::PlayerTemplatesController < ApplicationController
  def index
    players = PlayerTemplate.all
    render json: players, each_serializer: PlayerTemplateSerializer
  end

  def show
    player = PlayerTemplate.find_by id: params[:id]
    render json: player, serializer: PlayerTemplateSerializer
  end
end
