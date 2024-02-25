# frozen_string_literal: true

RSpec.describe GlobalRates do
  describe '.setup' do
    let(:rates) { [{ 'sailing_code' => 'ABC123', 'rate' => 100 }] }
    let(:exchange_rates) { { '2023-01-01' => { 'usd' => 1.2 } } }

    before do
      described_class.setup(rates, exchange_rates)
    end

    it 'correctly sets rates' do
      expect(described_class.rates).to eq(rates)
    end

    it 'correctly sets exchange_rates' do
      expect(described_class.exchange_rates).to eq(exchange_rates)
    end
  end

  describe 'attr_accessors' do
    it 'allows reading and writing for :rates' do
      new_rates = [{ 'sailing_code' => 'ABCD', 'rate' => 200 }]
      described_class.rates = new_rates
      expect(described_class.rates).to eq(new_rates)
    end

    it 'allows reading and writing for :exchange_rates' do
      new_exchange_rates = { '2023-02-01' => { 'eur' => 0.9 } }
      described_class.exchange_rates = new_exchange_rates
      expect(described_class.exchange_rates).to eq(new_exchange_rates)
    end
  end
end
