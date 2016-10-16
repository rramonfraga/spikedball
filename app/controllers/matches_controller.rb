class MatchesController < ApplicationController
  before_action :authenticate_user!

  def show
    @match = Match.find_by(id: params[:id])
    render status: 404, file: '/public/404.html' unless @match
  end

  def edit
    @match = Match.find_by(id: params[:id])
    render status: 404, file: '/public/404.html' unless @match
  end

  def update
    if @match = Match.find_by(id: params[:id])
      if @match.update_attributes(params)
        render :show
      else
        render :edit, status: :bad_request
      end
    else
      render status: 404, file: '/public/404.html'
    end
  end

  def finish
    @match = Match.find_by(id: params[:id])
    if @match.update_attributes(match_params)
      @match.finish!
      redirect_to action: 'show', controller: 'championships', community_code: current_community.code, id: params['championship_id']
    else
      redirect_to action: 'new', controller: 'feats', community_code: current_community.code, championship_id: params['championship_id'], match_id: params['match_id']
    end
  end

  private
  def match_params
    params.require(:match).permit(:host_team_treasury, :visit_team_treasury, :host_team_fan_factor, :visit_team_fan_factor)
  end
end
