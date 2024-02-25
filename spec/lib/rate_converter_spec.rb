# frozen_string_literal: true

RSpec.describe RateConverter do
  describe '.to_eur' do
    let(:departure_date) { '2022-01-29' }
    let(:exchange_rates) { { '2022-01-29' => { 'usd' => 1.2, 'eur' => 1.0 } } }

    before do
      @shipping_data = load_shipping_data
      allow(GlobalRates).to receive(:exchange_rates).and_return(exchange_rates)
    end

    context 'when the rate currency is already EUR' do
      let(:sailing) { instance_double('Sailing', departure_date: departure_date, rate_currency: 'EUR', rate: 100) }

      it 'returns the rate without conversion' do
        expect(described_class.to_eur(sailing)).to eq(100)
      end
    end

    context 'when the rate currency is not EUR and exchange rate is available' do
      let(:sailing) { instance_double('Sailing', departure_date: departure_date, rate_currency: 'USD', rate: 100) }

      it 'converts the rate to EUR' do
        expect(described_class.to_eur(sailing)).to eq(83.33)
      end
    end

    # context 'when the exchange rate is not available' do
    #   it 'raises an error' do
    #     allow(GlobalRates).to receive(:exchange_rates).and_return({})
    #     expect { described_class.to_eur(sailing) }.to raise_error(KeyError)
    #   end
    # end
  end
end
