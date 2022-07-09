class ProductionProcessesController < ApplicationController
  def index
    render json: ProductionProcess.all
  end

  def show
    render json: ProductionProcess.find(params[:id])
  end

  def natural_capital_filter
    @production_processes = ProductionProcess.sub_industry_production_process_filter(params[:sub_industry_ids])

    render json: @production_processes.map(&:to_formatted_json)
  end
end
