class HazardsController < ApplicationController
  before_action :set_hazard, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

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
    @hazards = Hazard.order(sort_column + " " + sort_direction)
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
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @hazard.update_attributes(hazard_params)
      respond_to do |format|
        format.html { redirect_to @hazard }
        format.js
      end
    else
      render 'edit'
    end
  end

  def destroy
    @hazard.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  private
    def hazard_params
      params.require(:hazard).permit(:name, :hazard_type_combo, :postal_code, :injuries, :fatalities, :property_damage, :crop_damage, :hazard_id, :fips_code, :hazard_begin_date, :hazard_end_date, :remarks)
    end

    def set_hazard
      @hazard = Hazard.find(params[:id])
    end

    def sort_column
      Hazard.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
