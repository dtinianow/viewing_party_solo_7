class Movie
    attr_reader :title, :vote_average

    def initialize(movie_params)
        @title = movie_params["title"]
        @vote_average = movie_params["vote_average"]
    end

    def self.by_query(query)
      Movie.service.get_movies_by_query(query)
    end

    def self.top_rated
      Movie.service.get_top_rated_movies
    end

    private

    def self.service
      MovieService.new
    end
end