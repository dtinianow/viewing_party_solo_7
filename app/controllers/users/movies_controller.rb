module Users
  class MoviesController < ApplicationController
    before_action :set_user

    def index
      @movies = params[:query] ? Movie.by_query(params[:query]) : Movie.top_rated
    rescue StandardError
      flash[:error] = 'Failed to fetch data. Please try again later.'
      redirect_to discover_user_path(@user)
    end

    def show
      @movie = Movie.find(params[:id])
    rescue StandardError
      flash[:error] = 'Failed to fetch data. Please try again later.'
      redirect_to user_movies_path(@user)
    end

    def similar
      @movies = Movie.similar_movies(params[:id])
    rescue StandardError
      flash[:error] = 'Failed to fetch data. Please try again later.'
      redirect_to user_movie_path(@user, params[:id])
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end
  end
end
