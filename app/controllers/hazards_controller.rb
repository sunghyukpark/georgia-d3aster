class HazardsController < ApplicationController
  before_action :get_hazard, only: [:update]

  # displays page for import
  def import_new
  end

  # import csv file
  def import
    Hazard.import(params[:file])
    redirect_to root_url, notice: "Hazards imported."
  end

  # display list of hazards
  def index
    @hazards = Hazard.all
  end

  # display form to create new hazard
  def new
    @hazard = Hazard.new
  end

  # create new hazard
  def create
    @hazard = Hazard.new(hazard_params)

    if @hazard.save
      respond_to do |format|
        format.html { redirect_to @hazard }
        format.js
      end
    else
      render 'new'
    end
  end

  # display hazard
  def show
    @hazard = Hazard.find(params[:id])
  end

  # display form for edit
  def edit
    @hazard = Hazard.find(params[:id])
  end

  # edit hazard
  def update
    if @hazard.update(hazard_params)
      redirect_to @hazard
    else
      render 'edit'
    end
  end

  # destroy a specific hazard
  def destroy
    @hazard = Hazard.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  private
    def hazard_params
      params.require(:hazard).permit(:id, :name, :hazard_type_combo, :postal_code, :injuries, :fatalities, :property_damage, :crop_damage, :hazard_id, :fips_code, :hazard_begin_date, :hazard_end_date, :remarks)
    end

    def get_hazard
      @hazard = Hazard.find(hazard_params)
    end
end
