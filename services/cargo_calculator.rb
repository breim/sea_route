# frozen_string_literal: true

require 'date'
require 'json'
require 'pry-byebug'

class CargoCalculator
  def initialize(json_file)
    @shipping_data = ShippingData.new(json_file)
    setup_global_rates
    load_sailings
  end

  def cheapest_direct_route(origin, destination)
    direct_sailings = RouterFinder.direct_routes(@sailings, origin, destination)
    direct_sailings.min_by(&:rate_in_euro)
  end

  def possible_routes(origin, destination)
    RouterFinder.all_routes(@sailings, origin, destination)
  end

  def cheapest_route(direct_routes, indirect_routes)
    router_calculator = RouterCalculator
    router_calculator.calculate_total_rate_for_direct_routes(direct_routes)
    router_calculator.calculate_total_rate_for_indirect_routes(indirect_routes)

    cheapest_route = router_calculator.find_cheapest_route(direct_routes, indirect_routes)
    cheapest_route.is_direct ? [cheapest_route] : router_calculator.retrieve_full_indirect_route(indirect_routes, cheapest_route)
  end

  def find_fasted_leg(origin, destination)
    routes = RouterFinder.all_routes(@sailings, origin, destination)
    (routes[:direct_routes] + routes[:indirect_routes].flatten).min_by(&:travel_duration)
  end

  private

  def setup_global_rates
    GlobalRates.setup(@shipping_data.rates, @shipping_data.exchange_rates)
  end

  def load_sailings
    @sailings = @shipping_data.sailings.map { |sailing_data| Sailing.new(sailing_data) }
  end
end
