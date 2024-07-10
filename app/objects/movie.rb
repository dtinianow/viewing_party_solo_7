class Movie
  attr_reader :genres, :id, :overview, :runtime, :title, :vote_average

  def initialize(params)
    # @cast #from other endpoint
    # @genres = parse_genres(params['genres'])
    @id = params['id']
    # @overview = params['overview']
    @title = params['title']
    # @review_count #from other endpoint
    # @reviews #from other endopint, includes author and info
    # @runtime = params['runtime'] #needs formatting
    @vote_average = params['vote_average']
  end

  def self.find(id)
    Movie.service.get_movie(id)
  end

  def self.by_query(query)
    Movie.service.get_movies_by_query(query)
  end

  def self.top_rated
    Movie.service.get_top_rated_movies
  end

  def self.service
    MovieService.new
  end

  private

  def parse_genres(genres)
    genres.map { |genre| genre['name'] }
  end
end