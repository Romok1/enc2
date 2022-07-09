module Concerns::BiodiversityGoalsDashboard
  extend ActiveSupport::Concern
  included do
    include Concerns::PDFDownloadable
    include Concerns::PortfolioAuthorization

    before_action :authenticate_user!, only: %i[index fetch_pdf create_pdf], unless: :puppeteer_call
    before_action :authorize_owner, only: %i[index create_pdf]

    private

    def set_portfolio_request_structure
      return unless portfolio

      request_structure = portfolio.request_structure[dashboard_params_key]

      if params[dashboard_params_key.to_sym]
        params[portfolio_dashboard_params_key.to_sym] = request_structure
      else
        params[dashboard_params_key] = request_structure
      end
    end

    def are_dashboard_selections_same_as_portfolio?
      if params[portfolio_dashboard_params_key.to_sym]
        return are_hash_arrays_equal?(
          params[portfolio_dashboard_params_key.to_sym],
          params[dashboard_params_key]
        )
      end

      true
    end

    def portfolio
      if params[:portfolio]
        portfolio = Portfolio.find(params[:portfolio])
        portfolio_user = portfolio.user
        if params[:auth_token] && params[:auth_token] == Rails.application.credentials.encore_auth_token
          user = User.find(params[:user_id])
        else
          user = current_user
        end
        portfolio_user == user ? portfolio : nil
      end
    end

    def dashboard_params_key
      params[:controller].classify.demodulize.underscore
    end

    def portfolio_dashboard_params_key
      "portfolio_#{dashboard_params_key}"
    end

    def module_name
      controller_name.to_s.gsub(/_dashboard/, '')
    end
  end
end
