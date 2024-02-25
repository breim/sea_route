# frozen_string_literal: true

require 'rack/test'

RSpec.describe 'App' do
  include Rack::Test::Methods

  def app
    App
  end

  let(:sailing) do
    double('Sailing', origin_port: 'CNSHA', destination_port: 'NLRTM', departure_date: '2022-01-30',
                      arrival_date: '2022-03-05', sailing_code: 'MNOP', rate: 456.78, rate_currency: 'USD')
  end

  let(:sailing_leg) do
    double('Sailing', origin_port: 'ESBCN', destination_port: 'NLRTM', departure_date: '2022-02-16',
                      arrival_date: '2022-02-20', sailing_code: 'ETRG', rate: 69.96, rate_currency: 'USD')
  end

  describe 'GET /cheap_direct_route' do
    before do
      get '/cheap_direct_route', origin: 'CNSHA', destination: 'NLRTM'
    end

    it 'returns the cheapest direct route' do
      expect(last_response).to be_ok
      expect(last_response.body).to include('origin')
      expect(last_response.body).to include('destination')

      expect(JSON.parse(last_response.body)['sailing_code']).to eq(sailing.sailing_code)
    end
  end

  describe 'GET /cheapest_direct_or_indirect_route' do
    it 'returns the cheapest route, direct or indirect' do
      get '/cheapest_direct_or_indirect_route', origin: 'CNSHA', destination: 'NLRTM'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body).size).to eq(2)
      expect(JSON.parse(last_response.body).first['origin_port']).to eq(sailing.origin_port)
    end
  end

  describe 'GET /fastest_sailing_leg' do
    it 'returns the fastest sailing leg' do
      get '/fastest_sailing_leg', origin: 'CNSHA', destination: 'NLRTM'
      expect(last_response).to be_ok
      expect(last_response.body).to include('origin')
      expect(last_response.body).to include('destination')

      expect(JSON.parse(last_response.body)['sailing_code']).to eq(sailing_leg.sailing_code)
    end
  end
end
