class SectorsController < ApplicationController
  def index
    @sectors = Rails.cache.fetch('sectors', expires_in: 1.month) { Sector.all }

    respond_to do |format|
      format.html {}
      format.json { render json: @sectors.map(&:to_formatted_json) }
    end
  end

  def show
    @sector = Sector.find(params[:id])

    respond_to do |format|
      format.html {}
      format.json { render json: @sector.to_formatted_json }
    end
  end
end
