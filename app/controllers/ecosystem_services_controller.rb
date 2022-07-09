class EcosystemServicesController < ApplicationController
  def index
    @services = EcosystemService.all.includes(:translations, assets: :translations, materialities: [:translations, production_process: :translations])

    respond_to do |format|
      format.html {}
      format.json { render json: @services.map(&:to_formatted_json) }
    end
  end

  def show
    @service = EcosystemService.find(params[:id])

    respond_to do |format|
      format.html {}
      format.json { render json: @service.to_formatted_json }
    end
  end
end
