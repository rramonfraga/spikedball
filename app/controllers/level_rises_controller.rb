class LevelRisesController < ApplicationController
  before_action :set_level_rise, only: [:show, :edit, :update, :destroy]

  def index
    @level_rises = LevelRise.all
  end

  def show
  end

  def edit
  end

  def create
    @level_rise = LevelRise.new(level_rise_params)

    respond_to do |format|
      if @level_rise.save
        format.html { redirect_to @level_rise, notice: 'Level rise was successfully created.' }
        format.json { render :show, status: :created, location: @level_rise }
      else
        format.html { render :new }
        format.json { render json: @level_rise.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @level_rise.update(level_rise_params)
        format.html { redirect_to @level_rise, notice: 'Level rise was successfully updated.' }
        format.json { render :show, status: :ok, location: @level_rise }
      else
        format.html { render :edit }
        format.json { render json: @level_rise.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_level_rise
      @level_rise = LevelRise.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def level_rise_params
      params.require(:level_rise).permit(:player_id, :first_dice, :second_dice, :title, :feat_id, :skill_id, :characteristic, :value)
    end
end
