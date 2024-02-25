# frozen_string_literal: true

module RouterFinder
  module_function

  def direct_routes(sailings, origin, destination)
    direct_routes = []

    sailings.filter_map do |sailing|
      next unless sailing.origin_port == origin && sailing.destination_port == destination

      direct_routes << sailing
      sailing.is_direct = true
    end

    direct_routes
  end

  def indirect_routes(sailings, origin, destination)
    sailings.each_with_object([]) do |sailing, indirect_routes|
      next unless sailing.origin_port == origin

      sailings.each do |potential_end_leg|
        if potential_end_leg.origin_port == sailing.destination_port && potential_end_leg.destination_port == destination
          indirect_route = [sailing, potential_end_leg]
          indirect_routes << indirect_route
        end
      end
    end
  end

  def all_routes(sailings, origin, destination)
    direct_routes = direct_routes(sailings, origin, destination)
    indirect_routes = indirect_routes(sailings, origin, destination)

    { direct_routes: direct_routes, indirect_routes: indirect_routes }
  end
end
