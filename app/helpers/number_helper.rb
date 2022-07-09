module NumberHelper
  include ActionView::Helpers::NumberHelper

  def round_eco_risk_to_string(value)
    round_sensibly_to_string(value, 0)
  end

  def round_eco_risk(value)
    round_sensibly(value, 0)
  end

  def round_sensibly_to_string(value, precision = nil)
    if value > 0.1
      number_with_precision(
        value,
        precision: precision || suggested_precision(value),
        delimiter: ','
      )
    else
      format('%.2e', value)
    end
  end

  def round_sensibly(value, precision = nil)
    value.to_f.round(precision || suggested_precision(value))
  end

  def suggested_precision(value)
    value > 5000 ? 0 : 2
  end

  def friendly_small_number(number)
    sig_fig = number >= 10 ? 3 : 2

    format("%.#{sig_fig}g", number.to_f)
  end
end