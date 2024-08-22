class MovieService
  def initialize
    @_conn = Faraday.new(
      url: 'https://api.themoviedb.org/3/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{ENV['TMDB_TOKEN']}"
      }
    )
  end

  def get_movies_by_query(query)
    response = conn.get('search/movie') do |req|
      req.params['language'] = 'en-US'
      req.params['page'] = '1'
      req.params['query'] = query.to_s
      req.params['include_adult'] = 'false'
    end
    parse(response)['results'].first(20).map { |movie| Movie.new(movie) }
  end

  def get_top_rated_movies
    response = conn.get('movie/top_rated') do |req|
      req.params['language'] = 'en-US'
      req.params['page'] = '1'
    end
    parse(response)['results'].first(20).map { |movie| Movie.new(movie) }
  end

  def get_movie(id)
    movie = get_movie_details(id)
    movie.cast = get_cast(id)
    movie.reviews = get_reviews(id)
    movie
  end

  def get_watch_providers(id)
    response = conn.get("movie/#{id}/watch/providers")
    results = parse(response)['results']['US']
    buy_providers = results['buy'].map { |provider| WatchProvider.new(provider['logo_path'], 'buy') }
    rent_providers = results['rent'].map { |provider| WatchProvider.new(provider['logo_path'], 'rent') }
    buy_providers + rent_providers
  end

  private

  def get_movie_details(id)
    response = conn.get("movie/#{id}") do |req|
      req.params['language'] = 'en-US'
    end
    Movie.new(parse(response))
  end

  def get_cast(id)
    response = conn.get("movie/#{id}/credits") do |req|
      req.params['language'] = 'en-US'
    end
    parse(response)['cast'].first(10).map { |cast_member| CastMember.new(cast_member) }
  end

  def get_reviews(id)
    response = conn.get("movie/#{id}/reviews") do |req|
      req.params['language'] = 'en-US'
      req.params['page'] = '1'
    end
    parse(response)['results'].map { |review| Review.new(review) }
  end

  def parse(response)
    JSON.parse(response.body)
  end

  def conn
    @_conn
  end
end
