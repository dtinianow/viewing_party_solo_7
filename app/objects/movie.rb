class Movie
    attr_reader :title, :vote_average

    def initialize(movie_params)
        @title = movie_params["title"]
        @vote_average = movie_params["vote_average"]
    end
end