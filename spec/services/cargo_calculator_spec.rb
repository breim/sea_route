# frozen_string_literal: true

RSpec.describe CargoCalculator do
  let(:calculator) { described_class.new('spec/fixtures/response.json') }
  let(:origin) { 'Port A' }
  let(:destination) { 'Port B' }

  let(:sailings) do
    [
      double('Sailing', origin: 'Port A', destination: 'Port B', rate_in_euro: 100),
      double('Sailing', origin: 'Port A', destination: 'Port B', rate_in_euro: 50)
    ]
  end

  let(:possible_routes_return) do
    {
      direct_routes: [
        { origin: 'Origin', destination: 'Destiny', rate_in_euro: 100, travel_duration: 5 },
        { origin: 'Origin', destination: 'Destiny', rate_in_euro: 120, travel_duration: 4 }
      ],
      indirect_routes: [
        [
          { origin: 'Origin', destination: 'Intermediary', rate_in_euro: 80, travel_duration: 3 },
          { origin: 'Intermediary', destination: 'Destiny', rate_in_euro: 90, travel_duration: 2 }
        ]
      ]
    }
  end

  before do
    @shipping_data = load_shipping_data

    allow(GlobalRates).to receive(:rates).and_return(@shipping_data.rates)
    allow(GlobalRates).to receive(:exchange_rates).and_return(@shipping_data.exchange_rates)

    allow(RateConverter).to receive(:to_eur).and_return(100)
    allow(RouterFinder).to receive(:direct_routes).with(anything, origin, destination).and_return(sailings)
    allow(RouterFinder).to receive(:all_routes).with(anything, origin, destination).and_return(possible_routes_return)
  end

  describe '#initialize' do
    it 'initializes with the correct data' do
      cheapest_route = calculator.cheapest_direct_route(origin, destination)
      expect(cheapest_route).to eq(sailings.last)
    end

    it 'returns all possible routes between the origin and destination' do
      routes = calculator.possible_routes(origin, destination)

      expect(routes).to eq(possible_routes_return)
    end
  end

  describe '#cheapest_route' do
    let(:direct_routes) do
      [
        double('DirectRoute', origin: 'Port A', destination: 'Port B', travel_duration: 5, is_direct: true, rate_in_euro: 100),
        double('DirectRoute', origin: 'Port A', destination: 'Port B', travel_duration: 4, is_direct: true, rate_in_euro: 80)
      ]
    end
    let(:indirect_routes) do
      [
        [double('IndirectRoutePart1', origin: 'Port A', destination: 'Port C', rate_in_euro: 50, travel_duration: 3),
         double('IndirectRoutePart2', origin: 'Port C', destination: 'Port B', rate_in_euro: 20, travel_duration: 2, is_direct: false)]
      ]
    end

    before do
      allow(RouterCalculator).to receive(:calculate_total_rate_for_direct_routes).with(direct_routes)
      allow(RouterCalculator).to receive(:calculate_total_rate_for_indirect_routes).with(indirect_routes)
    end

    it 'returns the cheapest route as JSON' do
      allow(RouterCalculator).to receive(:find_cheapest_route).and_return(direct_routes.last)
      expected_response = [direct_routes.last]

      expect(calculator.cheapest_route(direct_routes, indirect_routes)).to eq(expected_response)
    end
  end

  describe '#find_fasted_leg' do
    let(:origin) { 'Port A' }
    let(:destination) { 'Port B' }

    let(:routes) do
      {
        direct_routes: [
          double('DirectRoute', origin: origin, destination: destination, travel_duration: 5)
        ],
        indirect_routes: [
          [double('IndirectRoutePart1', origin: origin, destination: 'Port C', travel_duration: 3),
           double('IndirectRoutePart2', origin: 'Port C', destination: destination, travel_duration: 2)]
        ]
      }
    end

    let(:expected_fastest_leg) { routes[:indirect_routes].flatten.min_by(&:travel_duration) }

    before do
      allow(RouterFinder).to receive(:all_routes).with(calculator.instance_variable_get(:@sailings), origin, destination).and_return(routes)
    end

    it 'finds and returns the fastest leg as JSON' do
      fastest_leg = calculator.find_fasted_leg(origin, destination)
      expect(fastest_leg).to eq(expected_fastest_leg)
    end
  end
end
