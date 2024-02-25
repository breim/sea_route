# frozen_string_literal: true

require 'json'

class Sailing
  attr_accessor :origin_port, :destination_port, :departure_date, :arrival_date, :sailing_code,
                :rate, :rate_currency, :is_direct, :rate_in_euro, :total_rate, :travel_duration

  def initialize(attributes = {})
    @origin_port = attributes['origin_port']
    @destination_port = attributes['destination_port']
    @departure_date = attributes['departure_date']
    @arrival_date = attributes['arrival_date']
    @sailing_code = attributes['sailing_code']

    rate_details = rate_data
    @rate = rate_details['rate'].to_f
    @rate_currency = rate_details['rate_currency']
    @rate_in_euro = calculate_euro_rate
    @total_rate = nil
    @is_direct = false
    @travel_duration = duration
  end

  def to_json(*_args)
    {
      origin_port: @origin_port,
      destination_port: @destination_port,
      departure_date: @departure_date,
      arrival_date: @arrival_date,
      sailing_code: @sailing_code,
      rate: @rate,
      rate_currency: @rate_currency
    }.to_json
  end

  private

  def rate_data
    GlobalRates.rates.find { |rate| rate['sailing_code'] == @sailing_code }
  end

  def calculate_euro_rate
    RateConverter.to_eur(self)
  end

  def duration
    (Date.parse(@arrival_date) - Date.parse(@departure_date)).to_i
  end
end
