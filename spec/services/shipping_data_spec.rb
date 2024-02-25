# frozen_string_literal: true

RSpec.describe ShippingData do
  describe '#initialize' do
    let(:json_file) { 'spec/fixtures/response.json' }
    let(:json_content) { '{"sailings": ["sailing1", "sailing2"], "rates": ["rate1", "rate2"], "exchange_rates": ["exchange_rate1", "exchange_rate2"]}' }
    let(:shipping_data) { ShippingData.new(json_file) }

    before do
      allow(File).to receive(:read).with(json_file).and_return(json_content)
      allow(JSON).to receive(:parse).with(json_content).and_return(JSON.parse(json_content))
    end

    before(:each) do
      shipping_data
    end

    it 'sets sailings from the json file' do
      expect(shipping_data.sailings).to eq(%w[sailing1 sailing2])
    end

    it 'sets rates from the json file' do
      expect(shipping_data.rates).to eq(%w[rate1 rate2])
    end

    it 'sets exchange_rates from the json file' do
      expect(shipping_data.exchange_rates).to eq(%w[exchange_rate1 exchange_rate2])
    end
  end
end
