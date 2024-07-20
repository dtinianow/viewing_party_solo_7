class CastMember
  attr_reader :character, :name

  def initialize(params)
    @character = params['character']
    @name = params['name']
  end
end
