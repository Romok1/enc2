class EcosystemServicesAssetsJoinsController < ApplicationController
  def show
    @ecosystem_service  = EcosystemService.find(params[:ecosystem_service_id])
    @asset              = Asset.find(params[:id])

    @ecosystem_services_assets_join = EcosystemServicesAssetsJoin.find_by(
      ecosystem_service:  @ecosystem_service,
      asset:              @asset
    )

    respond_to do |format|
      format.html {}
      format.json {
        render json: {
          ecosystem_service:              @ecosystem_service,
          asset:                          @asset,
          ecosystem_services_assets_join: @ecosystem_services_assets_join
        }
      }
    end
  end
end
