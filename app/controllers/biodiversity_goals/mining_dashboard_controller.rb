require 'csv'
class BiodiversityGoals::MiningDashboardController < ApplicationController
  include Concerns::BiodiversityGoalsDashboard
  include CompaniesHelper

  def index
    respond_to do |format|
      format.html { @data = data }
      format.json { render json: data }
    end
  end

  def create_pdf
    create_pdf_job(
      mining_pdf_params,
      "ENCORE-mining-dashboard-download-#{pdf_timestamp}",
      mining_pdf_params[:portfolio]
    )
  end

  def mines_present
    @mines_present = BiodiversityGoals::MiningDashboard::Indicators.count_mines(params[:mining_dashboard]).positive?

    render json: @mines_present
  end

  def validate
    unless params[:mining_dashboard].present?
      render({
        json: {
          errors: {
            base: [I18n.t('biodiversity_goals.validation.manual_input.params')]
          }
        },
        status: :bad_request
      })
    end
    if mining_dashboard.valid?
      render({ json: {}, status: :ok })
    else
      render({ json: { errors: mining_dashboard.errors_combined_with_nested_form_errors }, status: :unprocessable_entity })
    end
  end

  def csv_template
    file_path = "#{Rails.root}/lib/data/csv_templates/mining-portfolio-template.zip"

    send_file file_path, type: 'application/zip', filename: 'mining-portfolio-template.zip'
  end

  def upload_csv
    unless params[:csv_upload].present?
      render({ json: { errors: { base: [I18n.t('biodiversity_goals.validation.csv.not_found')] } }, status: :bad_request })
    end
    csv = ::BiodiversityGoals::MiningDashboard::CSV.new(csv_upload_params.path)
    if csv.valid?
      render({ json: csv.to_hash, status: :ok })
    else
      render({ json: { errors: csv.errors_combined_with_nested_form_errors }, status: :unprocessable_entity })
    end
  rescue ::CSV::MalformedCSVError
    render({ json: { errors: { base: [I18n.t('biodiversity_goals.validation.csv.malformed')] } }, status: :bad_request })
  end

  def overview
    return render({ status: :bad_request }) unless mining_dashboard_parameters

    response = mining_dashboard_parameters.map do |form|
      {
        company: company_from_id(form['company_id'], companies),
        countries: countries.where(iso_3: form['locations'])
      }
    end

    render({ json: response, status: :ok })
  end

  def companies
    Company.where(id: mining_dashboard_parameters.map { |form| form['company_id'] })
  end

  def countries
    Country.where(iso_3: mining_dashboard_parameters.flat_map { |form| form['locations'] })
  end

  private

  def data
    set_portfolio_request_structure

    return unless params[:mining_dashboard] && mining_dashboard.valid?

    data_hash = {
      forms: mining_dashboard.forms.map(&:to_hash),
      isDirty: !are_dashboard_selections_same_as_portfolio?,
      portfolio: portfolio ? portfolio.serialize : nil
    }

    calculated_indicators = mining_dashboard.indicators

    return data_hash if calculated_indicators.empty?

    calculated_indicators.merge!({
      alignment_options: ::BiodiversityGoals::MiningDashboard::Dashboard.alignment_options(
        current_user: pdf_user,
        alignment_option_params: mining_pdf_params[:alignment_options]
      )
    })

    serialized_dashboard = MiningDashboardSerializer.serialize(calculated_indicators)
    alignment_option_filters = ::BiodiversityGoals::MiningDashboard::Dashboard.alignment_option_filters(
      params[:alignment_options]
    )
    serialized_dashboard[:alignmentOptionFilterSelections] = alignment_option_filters
    data_hash[:dashboard] = serialized_dashboard

    data_hash
  end

  def mining_dashboard
    @mining_dashboard ||= ::BiodiversityGoals::MiningDashboard::Dashboard.new(mining_dashboard_parameters)
  end

  def mining_dashboard_parameters
    params
      .permit(
        mining_dashboard: [
          :company_id,
          { locations: [] }
        ]
      ).require(:mining_dashboard)
  end

  def mining_pdf_params
    pdf_params(:mining_dashboard, params.permit(alignment_options: {}).to_h, :index, mining_params)
  end

  def mining_params
    # Important that company_id is before locations
    # so that params are interpreted correctly when forming url for chrome instance
    params.permit(
      :portfolio,
      alignment_options: {},
      mining_dashboard: [
        :company_id,
        { locations: [] }
      ]
    )
  end

  def csv_upload_params
    params.require(:csv_upload)
  end

  def portfolio_same_as_dashboard?
    params[:portfolio_mining_dashboard] && are_hash_arrays_equal?(
      params[:portfolio_mining_dashboard],
      params[:mining_dashboard]
    )
  end
end
