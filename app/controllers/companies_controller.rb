class CompaniesController < ApplicationController
  def index
    @companies = Company.except_excluded_companies.order(:name).map { |c| { id: c.id, name: c.name } }

    render json: @companies
  end

  def show
    @company = Company.find_by(id: params[:id])

    render json: @company
  end

  def autocomplete
    @data = CompanyAutocomplete.autocomplete(params[:term])

    render json: @data
  end
end
