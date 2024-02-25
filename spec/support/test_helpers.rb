# frozen_string_literal: true

module TestHelpers
  def load_shipping_data
    json_file = File.join(File.dirname(__FILE__), '..', 'fixtures', 'response.json')
    @shipping_data = ShippingData.new(json_file)
  end
end
