class PortfolioSerializer
  attr_reader :portfolio,
    :options

  BASE_ATTRS = %i[
    id
    name
    portfolio_type
    request_structure
    overview
    path
    created_at
    updated_at
  ].freeze

  def self.serialize(portfolio, options = {})
    new(portfolio, options).serialize
  end

  def initialize(portfolio, options)
    @portfolio = portfolio
    @options = options
  end

  def serialize
    portfolio.slice(*BASE_ATTRS)
  end
end
