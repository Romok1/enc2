class CountriesController < ApplicationController
  def index
    # @countries = Rails.cache.fetch('countries', expires_in: 1.year) do
    #   Country.all
    # end
    @countries = Country
    @countries = @countries.where(iso_3: params.require(:iso_3)) if params[:iso_3].present?
    @countries = @countries.order(:name).distinct

    respond_to do |format|
      format.html {}
      format.json { render json: @countries }
    end
  end

  def agriculture_countries
    @agriculture_countries = Country.with_agriculture_countries.order(:name).distinct

    respond_to do |format|
      format.html {}
      format.json { render json: @agriculture_countries }
    end
  end
end
