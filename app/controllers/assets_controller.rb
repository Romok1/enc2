# coding: utf-8
class AssetsController < ApplicationController
  def index
    params["include"] ||="es"

    if params["include"] == "es" 
      @assets = 
        Asset.all.includes(:translations, ecosystem_services: [:translations, materialities: [:translations, production_process: :translations]])
    elsif (params["include"] == "id") 
      @assets = 
        Asset.all.includes(:translations, drivers: [:translations, impact_drivers: [:translations, impacts: [:translations, production_process: :translations]]])
    else
      return render json: {"error": "Bad 'include' parameter"}, :status => :bad_request
    end
    respond_to do |format|
      format.html {}
      format.json { render json: @assets.map{|a| a.to_formatted_json(params["include"])} }
    end
  end

  def show
    @asset                          = Asset.find(params[:id])
    @asset_ecosystem_service_joins  = @asset.ecosystem_services_assets_joins
    @assets_drivers_joins           = @asset.assets_drivers_joins

    respond_to do |format|
      format.html {}
      format.json { render json: @asset.to_formatted_json }
    end
  end
end
