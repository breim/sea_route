# frozen_string_literal: true

module RouterCalculator
  module_function

  def calculate_total_rate_for_indirect_routes(indirect_routes)
    indirect_routes.each do |routes|
      routes.first.total_rate = routes.sum(&:rate_in_euro)
    end
  end

  def calculate_total_rate_for_direct_routes(direct_routes)
    direct_routes.each { |route| route.total_rate = route.rate_in_euro }
  end

  def find_cheapest_route(direct_routes, indirect_routes)
    combined_routes = direct_routes + indirect_routes.map(&:first)
    combined_routes.min_by(&:total_rate)
  end

  def retrieve_full_indirect_route(indirect_routes, cheapest_route)
    indirect_routes.find do |route|
      route.first.total_rate == cheapest_route.total_rate
    end
  end
end
