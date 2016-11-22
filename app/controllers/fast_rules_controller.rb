class FastRulesController < ApplicationController
  def index
    @skills = SkillTemplate.all
  end
end
