class DriversController < ApplicationController
  def index
    @drivers = Driver.all

    respond_to do |format|
      format.html {}
      format.json { render json: @drivers }
    end
  end

  def show
    @driver         = Driver.find(params[:id])

    respond_to do |format|
      format.html {}
      format.json { render json: @driver }
    end
  end
end
