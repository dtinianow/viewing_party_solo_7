class WatchProvider
  attr_reader :type, :logo_path

  TYPES = { rent: 'rent', buy: 'buy' }.freeze

  def initialize(logo_path, type)
    @logo_path = logo_path
    @type = type
  end

  def self.rent_providers(providers)
    providers.select { |provider| provider.type == 'rent' }
  end

  def self.buy_providers(providers)
    providers.select { |provider| provider.type == 'buy' }
  end
end
