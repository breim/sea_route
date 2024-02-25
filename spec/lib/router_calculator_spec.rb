# frozen_string_literal: true

RSpec.describe RouterCalculator do
  route = Struct.new(:rate_in_euro, :total_rate)

  let(:direct_route) { route.new(100, nil) }
  let(:indirect_route_part1) { route.new(50, nil) }
  let(:indirect_route_part2) { route.new(60, nil) }
  let(:indirect_route) { [indirect_route_part1, indirect_route_part2] }

  describe '.calculate_total_rate_for_direct_routes' do
    it 'calculates and sets the total rate for direct routes' do
      RouterCalculator.calculate_total_rate_for_direct_routes([direct_route])
      expect(direct_route.total_rate).to eq(100)
    end
  end

  describe '.calculate_total_rate_for_indirect_routes' do
    it 'calculates and sets the total rate for the first route in each set of indirect routes' do
      RouterCalculator.calculate_total_rate_for_indirect_routes([indirect_route])
      expect(indirect_route.first.total_rate).to eq(110)
    end
  end

  describe '.find_cheapest_route' do
    let(:more_expensive_direct_route) { route.new(200, nil) }
    before do
      RouterCalculator.calculate_total_rate_for_direct_routes([more_expensive_direct_route])
      RouterCalculator.calculate_total_rate_for_indirect_routes([indirect_route])
    end

    it 'finds the cheapest route among direct and indirect routes' do
      cheapest_route = RouterCalculator.find_cheapest_route([more_expensive_direct_route], [indirect_route])
      expect(cheapest_route).to eq(indirect_route.first)
    end
  end

  describe '.retrieve_full_indirect_route' do
    before do
      RouterCalculator.calculate_total_rate_for_indirect_routes([indirect_route])
    end

    it 'retrieves the full indirect route for the cheapest route' do
      cheapest_route = RouterCalculator.find_cheapest_route([], [indirect_route])
      full_route = RouterCalculator.retrieve_full_indirect_route([indirect_route], cheapest_route)
      expect(full_route).to eq(indirect_route)
    end
  end
end
