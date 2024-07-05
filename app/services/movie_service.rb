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
    response = conn.get("search/movie") do |req|
      req.params['query'] = "#{query}"
      req.params['include_adult'] = 'false'
      default_params.each { |k, v| req.params[k] = v }
    end
    parse(response)
  end

  def get_top_rated_movies
    response = conn.get("movie/top_rated") do |req|
      default_params.each { |k, v| req.params[k] = v }
    end
    parse(response)
  end

  private

  def default_params
    { 'language': 'en-US', 'page': '1'}
  end

  def parse(response)
    JSON.parse(response.body)["results"].first(20).map { |movie_info| Movie.new(movie_info) }
  end

  def conn
    @_conn
  end
end