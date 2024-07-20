module Users
  class MoviesController < ApplicationController
    def index
      @user = User.find(params[:user_id])
      @movies = params[:query] ? Movie.by_query(params[:query]) : Movie.top_rated
    rescue StandardError
      flash[:error] = 'Failed to fetch data. Please try again later.'
      redirect_to discover_user_path(@user)
    end

    def show
      @user = User.find(params[:user_id])
      @movie = Movie.find(params[:id])
    rescue StandardError
      flash[:error] = 'Failed to fetch data. Please try again later.'
      redirect_to user_movies_path(@user)
    end
  end
end
