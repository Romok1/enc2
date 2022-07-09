require 'csv'
module BiodiversityGoals
  class AgricultureDashboardController < ApplicationController
    include Concerns::BiodiversityGoalsDashboard

    def index
      respond_to do |format|
        format.html { @data = data }
        format.json { render json: data }
      end
    end

    def create_pdf
      create_pdf_job(
        agriculture_pdf_params, 
        "ENCORE-agri-dashboard-download-#{pdf_timestamp}",
        agriculture_pdf_params[:portfolio]
      )
    end

    def validate
      unless params[:agriculture_dashboard].present?
        render({
          json: {
            errors: {
              base: [I18n.t('biodiversity_goals.validation.manual_input.params')]
            }
          },
          status: :bad_request
        })
      end
      if agriculture_dashboard.valid?
        render({ json: {}, status: :ok })
      else
        render({ json: { errors: agriculture_dashboard.errors_combined_with_nested_form_errors }, status: :unprocessable_entity })
      end
    end

    def csv_template
      file_path = "#{Rails.root}/lib/data/csv_templates/agriculture-portfolio-template.zip"

      send_file file_path, type: 'application/zip', filename: 'agriculture-portfolio-template.zip'
    end

    def upload_csv
      unless params[:csv_upload].present?
        render({ json: { errors: { base: [I18n.t('biodiversity_goals.validation.csv.not_found')] } }, status: :bad_request })
      end
      csv = ::BiodiversityGoals::AgricultureDashboard::CSV.new(csv_upload_params.path)
      if csv.valid?
        render({ json: csv.to_hash, status: :ok })
      else
        render({ json: { errors: csv.errors_combined_with_nested_form_errors }, status: :unprocessable_entity })
      end
    rescue ::CSV::MalformedCSVError
      render({ json: { errors: { base: [I18n.t('biodiversity_goals.validation.csv.malformed')] } }, status: :bad_request })
    end

    def overview
      return render({ status: :bad_request }) unless agriculture_dashboard_parameters

      response = agriculture_dashboard_parameters.map do |form|
        {
          country: countries.find_by(iso_3: form['country']),
          crops_value: form['crops_value'].to_s.to_f,
          crops_area_type: form['crops_area_type'],
          livestock_value: form['livestock_value'].to_s.to_f,
          livestock_area_type: form['livestock_area_type']
        }
      end

      render({ json: response, status: :ok })
    end

    private

    def countries
      Country.with_agriculture_countries.where(iso_3: agriculture_dashboard_parameters.map { |form| form['country'] })
    end

    def data
      set_portfolio_request_structure

      return unless params[:agriculture_dashboard] && agriculture_dashboard.valid?

      data_hash = {
        forms: agriculture_dashboard.forms.map(&:to_hash),
        isDirty: !are_dashboard_selections_same_as_portfolio?,
        portfolio: portfolio ? portfolio.serialize : nil
      }

      calculated_indicators = agriculture_dashboard.indicators
      return data_hash if calculated_indicators.empty?

      calculated_indicators.merge!({
        alignment_options: ::BiodiversityGoals::AgricultureDashboard::Dashboard.alignment_options(
          current_user: pdf_user,
          alignment_option_params: agriculture_pdf_params[:alignment_options]
        )
      })

      serialized_dashboard = AgricultureDashboardSerializer.serialize(calculated_indicators)
      alignment_option_filters = ::BiodiversityGoals::AgricultureDashboard::Dashboard.alignment_option_filters(
        params[:alignment_options]
      )
      serialized_dashboard[:alignmentOptionFilterSelections] = alignment_option_filters
      data_hash[:dashboard] = serialized_dashboard

      data_hash
    end

    def agriculture_dashboard
      @agriculture_dashboard ||= ::BiodiversityGoals::AgricultureDashboard::Dashboard.new(agriculture_dashboard_parameters)
    end

    def agriculture_dashboard_parameters
      params
        .permit(
          agriculture_dashboard: %i[
            country
            crops_value
            crops_area_type
            livestock_value
            livestock_area_type
          ]
        ).require(:agriculture_dashboard)
    end

    def agriculture_pdf_params
      pdf_params(:agriculture_dashboard, params.permit(alignment_options: {}).to_h, :index, agriculture_params)
    end

    def agriculture_params
      # Important that country is before area and turnover
      # so that params are interpreted correctly when forming url for chrome instance
      params.permit(
        :portfolio,
        alignment_options: {},
        agriculture_dashboard: %i[
          country
          crops_area_type
          crops_value
          livestock_value
          livestock_area_type
        ]
      )
    end

    def csv_upload_params
      params.require(:csv_upload)
    end

    def portfolio_same_as_dashboard?
      params[:portfolio_agriculture_dashboard] && are_hash_arrays_equal?(params[:portfolio_agriculture_dashboard], params[:agriculture_dashboard])
    end
  end
end
