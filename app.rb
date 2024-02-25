# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug' if development?

['./services/**/*.rb', './lib/**/*.rb'].each do |path|
  Dir[File.join(File.dirname(__FILE__), path)].sort.each do |file|
    require file
  end
end

class App < Sinatra::Base
  CARGO_CALCULATOR = CargoCalculator.new('./response.json')

  # PLS-0001
  # http://localhost:9292/cheap_direct_route?origin=CNSHA&destination=NLRTM
  get '/cheap_direct_route' do
    origin = params[:origin]
    destination = params[:destination]

    response = CARGO_CALCULATOR.cheapest_direct_route(origin, destination)
    response.to_json
  end

  # WRT-0002
  # http://localhost:9292/cheapest_direct_or_indirect_route?origin=CNSHA&destination=NLRTM
  get '/cheapest_direct_or_indirect_route' do
    origin = params[:origin]
    destination = params[:destination]

    possible_routes = CARGO_CALCULATOR.possible_routes(origin, destination)
    response = CARGO_CALCULATOR.cheapest_route(possible_routes[:direct_routes], possible_routes[:indirect_routes])
    response.to_json
  end

  # TST-0003
  # http://localhost:9292/fastest_sailing_leg?origin=CNSHA&destination=NLRTM
  get '/fastest_sailing_leg' do
    origin = params[:origin]
    destination = params[:destination]

    response = CARGO_CALCULATOR.find_fasted_leg(origin, destination)
    response.to_json
  end
end
