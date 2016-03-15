class HazardsController < ApplicationController
  before_action :get_hazard, only: [:show, :edit, :update, :destroy]

  # display
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
      redirect_to @hazard
    else
      render 'new'
    end
  end

  # display hazard
  def show
  end

  # display form for edit
  def edit
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
    @hazard.destroy
    redirect_to root_path
  end

  private
    def hazard_params
      params.require(:hazard).permit(:name, :type, :postal_code, :injuries, :fatalities, :property_damage, :crop_damage, :hazard_id, :fips_code, :begin_date, :end_date)
    end

    def get_hazard
      @hazard = Hazard.find(hazard_params)
    end
end
