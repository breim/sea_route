# frozen_string_literal: true

RSpec.describe RouterFinder do
  sail = Struct.new(:origin_port, :destination_port, :is_direct)

  let(:sailings) do
    [
      sail.new('Port A', 'Port B', false),
      sail.new('Port B', 'Port C', false),
      sail.new('Port A', 'Port B', false)
    ]
  end

  describe '.direct_routes' do
    it 'returns only direct routes between specified origin and destination' do
      direct = RouterFinder.direct_routes(sailings, 'Port A', 'Port B')
      expect(direct.size).to eq(2)
      expect(direct.all?(&:is_direct)).to be true
      expect(direct.map(&:destination_port)).to all(eq 'Port B')
    end
  end

  describe '.indirect_routes' do
    it 'returns all possible indirect routes between specified origin and destination' do
      indirect = RouterFinder.indirect_routes(sailings, 'Port A', 'Port C')
      expect(indirect.size).to eq(2)
      indirect.each do |route|
        expect(route.first.origin_port).to eq('Port A')
        expect(route.last.destination_port).to eq('Port C')
      end
    end
  end

  describe '.all_routes' do
    it 'returns a hash with both direct and indirect routes' do
      all = RouterFinder.all_routes(sailings, 'Port A', 'Port C')
      expect(all[:direct_routes].size).to eq(0)
      expect(all[:indirect_routes].size).to eq(2)
    end
  end
end
