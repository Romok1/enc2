class ImpactDriversController < ApplicationController
  def index
    @impact_drivers = ImpactDriver.all.includes(impacts: [:translations, production_process: :translations], drivers: [:translations, assets: :translations])

    respond_to do |format|
      format.html {}
      format.json { render json: @impact_drivers.map(&:to_formatted_json) }
    end
  end

  def show
    @impact_driver = ImpactDriver.find(params[:id])

    respond_to do |format|
      format.html {}
      format.json { render json: @impact_driver.to_formatted_json(false)}
    end
  end
end
