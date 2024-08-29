module Users
  module Movies
    class ViewingPartiesController < ApplicationController
      before_action :set_user
      before_action :set_movie, except: %i[show]
      def new
        @viewing_party = ViewingParty.new
        @viewing_party.users.build
        @users = User.where.not(id: @user)
      end

      def create
        ActiveRecord::Base.transaction do
          @viewing_party = ViewingParty.new(
            viewing_party_params.merge(
              movie_title: @movie.title,
              movie_id_from_tmdb: @movie.id,
              movie_poster_path: @movie.poster_path
            )
          )
          @viewing_party.save!
          UserParty.create!(user: @user, viewing_party: @viewing_party, host: true)
          params[:viewing_party][:user_ids]&.each do |user_id|
            UserParty.create!(user_id:, viewing_party: @viewing_party, host: false)
          end
          redirect_to user_path(@user), notice: 'Viewing party was successfully created.'
        rescue ActiveRecord::RecordInvalid => e
          @users = User.where.not(id: @user.id)
          flash[:error] = "There was a problem creating the viewing party: #{e.message}"
          render :new, status: :unprocessable_entity
        rescue StandardError => e
          @users = User.where.not(id: @user.id)
          flash[:error] = "There was a problem creating the viewing party: #{e.message}"
          render :new, status: :unprocessable_entity
        end
      end

      def show
        @viewing_party = ViewingParty.find(params[:id])
        @movie = Movie.new({ 'id' => @viewing_party.movie_id_from_tmdb, 'title' => @viewing_party.movie_title })
        @watch_providers = @movie.watch_providers
      rescue StandardError
        flash[:error] = 'Failed to fetch data. Please try again later.'
        redirect_to user_path(@user)
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end

      def set_movie
        @movie = Movie.find(params[:movie_id])
      end

      def viewing_party_params
        params.require(:viewing_party).permit(:date, :duration, :start_time)
      end
    end
  end
end
