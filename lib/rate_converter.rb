# frozen_string_literal: true

module RateConverter
  module_function

  def to_eur(sailing)
    return sailing.rate if sailing.rate_currency == 'EUR'

    exchange_rate = GlobalRates.exchange_rates[sailing.departure_date][sailing.rate_currency.downcase]
    (sailing.rate / exchange_rate).round(2)
  end
end
