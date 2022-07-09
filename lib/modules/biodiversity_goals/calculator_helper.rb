module BiodiversityGoals::CalculatorHelper
  def comparison_to_average(portfolio_average:, sector_average:)
    portfolio_average * 100 / sector_average
  end

  def humanize_comparison_to_average(percentage_difference)
    percentage_difference ||= 0
    # more than 5% above = above
    if percentage_difference > 105
      'above'
    else
      # more than 5% below = below
      # within 5% = average
      percentage_difference < 95 ? 'below' : 'average'
    end
  end
end