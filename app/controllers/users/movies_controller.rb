class Users::MoviesController < ApplicationController
    def index
        conn = Faraday.new(
            url: 'https://api.themoviedb.org',
            params: {'api_key': ENV['TMDB_API_KEY']},
            headers: {'Content-Type' => 'application/json'}
        )
        response = if params[:query]
             conn.get("https://api.themoviedb.org/3/search/movie?query=#{params[:query]}&include_adult=false&language=en-US&page=1")
        else
            conn.get("https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1")
        end
        @movies = JSON.parse(response.body)["results"].first(20).map { |movie_info| Movie.new(movie_info) }
        @user = User.find(params[:user_id])
    end
end
