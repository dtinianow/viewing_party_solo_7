class Users::MoviesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @movies = params[:query] ? Movie.by_query(params[:query]) : Movie.top_rated
  end
end
