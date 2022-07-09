class OrganisationTypesController < ApplicationController
  def index
    # @organisation_types = Rails.cache.fetch('organisation_types', expires_in: 1.year) do
    #   OrganisationType.all
    # end
    @organisation_types = OrganisationType.order(:name).distinct

    respond_to do |format|
      format.html {}
      format.json { render json: @organisation_types }
    end
  end
end
