class Api::TeamTemplatesController < ApplicationController
  def index
    teams = TeamTemplate.all
    render json: teams, each_serializer: TeamTemplateSerializer
  end

  def show
    team = TeamTemplate.find_by id: params[:id]
    render json: team, serializer: TeamTemplateSerializer
  end
end
