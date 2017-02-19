class TeamsController < ApplicationController
  before_action :authenticate_user!

  def index
    @teams = current_user.teams.all
  end

  def show
    @team = Team.find_by(id: params[:id])
    respond_to do |format|
      format.html do
        render 'show'
      end
      format.pdf do
        report = PdfDocument.new(@team)
        send_data report.to_pdf, filename: report.filename, type: 'application/pdf'
      end
    end
  end

  def new
    @team = current_user.teams.new
    16.times { @team.players.build }
  end

  def create
    @team = current_user.teams.new team_params
    if @team.save
      redirect_to action: 'show', controller: 'teams', id: @team.id
    else
      render(:new)
    end
  end

  def add_re_roll
    @team = Team.find_by(id: params[:id])
    @team.add_re_roll
    redirect_to action: 'show', controller: 'teams', id: @team.id
  end

  def add_apothecary
    @team = Team.find_by(id: params[:id])
    @team.add_apothecary
    redirect_to action: 'show', controller: 'teams', id: @team.id
  end

  def add_freelance
    @team = Team.find_by(id: params[:id])
    @team.add_freelance
    redirect_to action: 'show', controller: 'teams', id: @team.id
  end

  private
  def team_params
    params.require(:team).permit( :name,
                                  :team_template_id,
                                  :treasury,
                                  :re_rolls,
                                  :fan_factor,
                                  :assistant_coaches,
                                  :cheerleaders,
                                  :apothecaries,
                                  players_attributes: [:dorsal, :name, :player_template_id])
  end
end
