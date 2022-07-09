class AssetsDriversJoinsController < ApplicationController
  def show
    @asset  = Asset.find(params[:asset_id])
    @driver = Driver.find(params[:id])

    @assets_drivers_join = AssetsDriversJoin.find_by(
      asset: @asset,
      driver: @driver
    )

    respond_to do |format|
      format.html {}
      format.json {
        render json: {
          asset:              @asset,
          driver:             @driver,
          assets_drivers_join: @assets_drivers_join
        }
      }
    end
  end
end
