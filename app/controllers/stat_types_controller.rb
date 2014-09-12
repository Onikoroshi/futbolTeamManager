class StatTypesController < ApplicationController
  before_action :set_stat_type, only: [:show, :edit, :update, :destroy]

  # GET /stat_types
  # GET /stat_types.json
  def index
    @stat_types = StatType.all
  end

  # GET /stat_types/1
  # GET /stat_types/1.json
  def show
  end

  # GET /stat_types/new
  def new
    @stat_type = StatType.new
  end

  # GET /stat_types/1/edit
  def edit
  end

  # POST /stat_types
  # POST /stat_types.json
  def create
    @stat_type = StatType.new(stat_type_params)

    respond_to do |format|
      if @stat_type.save
        format.html { redirect_to @stat_type, notice: 'Stat type was successfully created.' }
        format.json { render :show, status: :created, location: @stat_type }
      else
        format.html { render :new }
        format.json { render json: @stat_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stat_types/1
  # PATCH/PUT /stat_types/1.json
  def update
    respond_to do |format|
      if @stat_type.update(stat_type_params)
        format.html { redirect_to @stat_type, notice: 'Stat type was successfully updated.' }
        format.json { render :show, status: :ok, location: @stat_type }
      else
        format.html { render :edit }
        format.json { render json: @stat_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stat_types/1
  # DELETE /stat_types/1.json
  def destroy
    @stat_type.destroy
    respond_to do |format|
      format.html { redirect_to stat_types_url, notice: 'Stat type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stat_type
      @stat_type = StatType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stat_type_params
      params.require(:stat_type).permit(:name)
    end
end
