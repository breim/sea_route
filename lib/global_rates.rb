# frozen_string_literal: true

module GlobalRates
  @rates = []
  @exchange_rates = {}

  class << self
    attr_accessor :rates, :exchange_rates
  end

  def self.setup(rates, exchange_rates)
    @rates = rates
    @exchange_rates = exchange_rates
  end
end
