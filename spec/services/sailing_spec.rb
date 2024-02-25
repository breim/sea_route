# frozen_string_literal: true

RSpec.describe Sailing do
  let(:attributes) do
    {
      'origin_port' => 'CNSHA',
      'destination_port' => 'ESBCN',
      'departure_date' => '2022-01-29',
      'arrival_date' => '2022-02-06',
      'sailing_code' => 'ERXQ',
      'rate' => 261.96,
      'rate_currency' => 'EUR'
    }
  end

  subject(:sailing) { described_class.new(attributes) }

  before do
    shipping_data = load_shipping_data
    allow(GlobalRates).to receive(:rates).and_return(shipping_data.rates)
    allow(GlobalRates).to receive(:exchange_rates).and_return(shipping_data.exchange_rates)
    allow(RateConverter).to receive(:to_eur).and_return(100)
  end

  describe '#initialize' do
    it 'assigns attributes correctly and calculates rate in euro and travel duration' do
      expect(sailing.origin_port).to eq('CNSHA')
      expect(sailing.destination_port).to eq('ESBCN')
      expect(sailing.departure_date).to eq('2022-01-29')
      expect(sailing.arrival_date).to eq('2022-02-06')
      expect(sailing.sailing_code).to eq('ERXQ')
      expect(sailing.rate).to eq(261.96)
      expect(sailing.rate_currency).to eq('EUR')
      expect(sailing.rate_in_euro).to eq(100)
      expect(sailing.travel_duration).to eq(8)
    end
  end

  describe '#to_json' do
    it 'returns a JSON string that matches the expected format' do
      json_output = sailing.to_json
      expected_json = {
        origin_port: 'CNSHA',
        destination_port: 'ESBCN',
        departure_date: '2022-01-29',
        arrival_date: '2022-02-06',
        sailing_code: 'ERXQ',
        rate: 261.96,
        rate_currency: 'EUR'
      }.to_json

      expect(json_output).to eq(expected_json)
    end
  end
end
