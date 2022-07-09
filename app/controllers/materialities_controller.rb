class MaterialitiesController < ApplicationController
  def show
    @production_process = ProductionProcess.find(params[:production_process_id])
    @ecosystem_service  = EcosystemService.find(params[:id])
    @materiality        = Materiality.find_by(
      production_process: @production_process,
      ecosystem_service: @ecosystem_service
    )

    respond_to do |format|
      format.html {}
      format.json {
        render json: {
          production_process: @production_process,
          ecosystem_service:  @ecosystem_service,
          materiality:        @materiality
        }
      }
    end
  end
end
