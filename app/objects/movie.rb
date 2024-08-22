class Movie
  attr_reader :genres, :id, :overview, :runtime, :title, :vote_average
  attr_accessor :cast, :reviews

  def initialize(params)
    @genres = parse_genres(params['genres']) if params['genres']
    @id = params['id']
    @overview = params['overview']
    @title = params['title']
    @runtime = params['runtime']
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

  def watch_providers
    Movie.service.get_watch_providers(id)
  end

  private

  def parse_genres(genres)
    genres.map { |genre| genre['name'] }
  end
end
