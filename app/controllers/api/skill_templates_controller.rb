class Api::SkillTemplatesController < ApplicationController
  def index
    skills = SkillTemplate.all
    render json: skills, each_serializer: SkillTemplateSerializer
  end

  def show
    skill = SkillTemplate.find_by id: params[:id]
    render json: skill, serializer: SkillTemplateSerializer
  end
end
