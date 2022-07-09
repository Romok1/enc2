class PortfoliosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_portfolio, only: %i[show update destroy]

  include Concerns::Portfolios::Agriculture
  include Concerns::Portfolios::Mining
  include Concerns::Portfolios::NaturalCapital

  PORTFOLIO_TYPES = %w[
    agriculture
    mining
    natural_capital
  ].freeze

  # GET /portfolios
  # GET /portfolios.json
  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        load_portfolios
        render json: @portfolios.map(&:serialize)
      end
    end
  end

  # GET /portfolios/1
  # GET /portfolios/1.json
  def show
    respond_to do |format|
      format.html { redirect_to @portfolio.path }
      format.json { render json: @portfolio.serialize }
    end
  end

  # POST /portfolios
  # POST /portfolios.json
  def create
    @portfolio = current_user.portfolios.build(portfolio_params)

    respond_to do |format|
      if @portfolio.save
        format.json { render json: @portfolio.serialize }
      else
        if params[:overwrite]
          @portfolio = current_user.portfolios.find_by(name: portfolio_params[:name])
          return update
        end
        format.json { render json: error_response, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portfolios/1
  # PATCH/PUT /portfolios/1.json
  def update
    @portfolio.name = portfolio_params[:name]

    return create if @portfolio.name_changed?

    ActiveRecord::Base.transaction do
      @portfolio.assign_attributes(portfolio_params)

      respond_to do |format|
        if @portfolio.save!
          @portfolio.touch
          format.json { render json: @portfolio.serialize }
        else
          format.json { render json: error_response, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /portfolios/1
  # DELETE /portfolios/1.json
  def destroy
    @portfolio.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def error_response
    errors = {
      errors: @portfolio.errors.as_json
    }
    errors[:prompt_overwrite] = true if @portfolio.errors.added?(:name, I18n.t('errors.messages.taken'))
    errors
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def portfolio_params
    portfolio_params = params.require(:portfolio)

    raise 'Invalid portfolio_type' unless PORTFOLIO_TYPES.include?(portfolio_params[:portfolio_type])

    portfolio_params.permit(
      :name,
      :portfolio_type,
      request_structure: send("#{portfolio_params[:portfolio_type]}_request_structure")
    )
  end

  def set_portfolio
    @portfolio = current_user.portfolios.find(params[:id])
  end

  def load_portfolios
    @portfolios = current_user.portfolios
      .where(like_sql(params[:name]))
      .order(order_by_sql(params[:order_by], params[:direction]))
      .limit(params[:limit])
  end

  def like_sql(search_term)
    search_term ? ("name ILIKE '%" << search_term << "%'") : nil
  end

  def order_by_sql(column, ordering)
    format(
      '%<column>s %<ordering>s',
      {
        column: %w[name created_at updated_at].include?(column) ? column : 'name',
        ordering: %w[asc desc].include?(ordering) ? ordering : 'asc'
      }
    )
  end
end
