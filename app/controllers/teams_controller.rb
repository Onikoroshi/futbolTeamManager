class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :add_player, :remove_player, :add_jersey_to_player, :recover_jersey_from_player]
  before_action :set_player, only: [:add_player, :remove_player, :add_jersey_to_player, :recover_jersey_from_player]
  before_action :set_jersey, only: [:add_player, :add_jersey_to_player]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /teams/1/add_player
  # possible params:
  #   player_id
  #   jersey
  def add_player
    @team.add_player(@player, @jersey)

    redirect_to team_path(@team)
  end

  # POST /teams/1/remove_player
  # possible params:
  #   player_id
  def remove_player
    @team.remove_player(@player)

    redirect_to team_path(@team)
  end

  # POST /teams/1/add_jersey_to_player
  # possible params:
  #   player_id
  #   jersey
  def add_jersey_to_player
    @team.assign_jersey(@player, @jersey)

    redirect_to team_path(@team)
  end

  # POST /teams/1/add_jersey_to_player
  # possible params:
  #   player_id
  #   jersey
  def recover_jersey_from_player
    @team.unassign_jersey(@player)

    redirect_to team_path(@team)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    def set_player
      @player = Player.find_by(id: params[:player_id])
    end

    def set_jersey
      @jersey = params[:jersey]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :available_jerseys)
    end
end
