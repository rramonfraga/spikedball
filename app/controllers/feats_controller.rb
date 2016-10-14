class FeatsController < ApplicationController
  before_action :authenticate_user!

  def new
    @match = Match.find_by(id: params[:match_id])
    @feat = @match.feats.new
    @players = @match.host_team.players + @match.visit_team.players
  end

  def create
    @match = Match.find_by(id: params[:match_id])
    @feat = @match.feats.new feat_params
    if @feat.save
      redirect_to action: 'new', controller: 'feats', community_code: current_community.code, championship_id: params["championship_id"], match_id: params["match_id"]
    else
      render(:new)
    end
  end

  def destroy
    @feat = Feat.find_by(id: params[:id])
    @feat.destroy
    redirect_to action: 'new', controller: 'feats', community_code: current_community.code, championship_id: params["championship_id"], match_id: params["match_id"]
  end

  private
  def feat_params
    params.require(:feat).permit(:player_id, :kind, :injury)
  end
end
