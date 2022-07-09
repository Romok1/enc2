# frozen_string_literal: true

class Portfolio < ApplicationRecord
  include Concerns::Portfolios::Agriculture
  include Concerns::Portfolios::Mining
  include Concerns::Portfolios::NaturalCapital

  belongs_to :user

  validates_presence_of :request_structure
  validates :name, presence: true, uniqueness: { scope: :user_id }

  validates :portfolio_type, inclusion: {
    in: %w[
      agriculture
      mining
      natural_capital
    ],
    message: '%<value>s is not a valid type'
  }

  enum portfolio_type: {
    agriculture: 'agriculture',
    mining: 'mining',
    natural_capital: 'natural_capital'
  }

  def overview
    send("#{portfolio_type}_overview")
  end

  def path
    Rails.application.routes.url_helpers.public_send("#{portfolio_type}_dashboard_path", portfolio: self)
  end

  def serialize(options = {})
    PortfolioSerializer.serialize(self, options)
  end
end
