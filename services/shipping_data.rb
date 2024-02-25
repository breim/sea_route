# frozen_string_literal: true

require 'json'

class ShippingData
  attr_reader :sailings, :rates, :exchange_rates

  def initialize(json_file)
    file = File.read(json_file)
    data = JSON.parse(file)
    @sailings = data['sailings']
    @rates = data['rates']
    @exchange_rates = data['exchange_rates']
  end
end
