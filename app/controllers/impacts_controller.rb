class ImpactsController < ApplicationController
  def show
    @production_process = ProductionProcess.find(params[:production_process_id])
    @impact_driver = ImpactDriver.find(params[:id])
    @impact = Impact.find_by(
      production_process: @production_process,
      impact_driver: @impact_driver
    )

    respond_to do |format|
      format.html {}
      format.json {
        render json: {
          production_process: @production_process,
          impact_driver: @impact_driver,
          impact: @impact
        }
      }
    end
  end

end
