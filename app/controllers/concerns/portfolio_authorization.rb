module Concerns::PortfolioAuthorization
  extend ActiveSupport::Concern
  included do
    def authorize_owner(portfolio_id = nil)
      return if user_owns_portfolio?(portfolio_id)

      head(403)
    rescue ActiveRecord::RecordNotFound, NoMethodError
      head(422)
    end

    def user_owns_portfolio?(portfolio_id = nil)
      portfolio_id ||= dashboard_pdf_params[:portfolio]

      return true if portfolio_id.blank?

      portfolio = Portfolio.find(portfolio_id)

      pdf_user.id == portfolio.user.id
    end
  end
end