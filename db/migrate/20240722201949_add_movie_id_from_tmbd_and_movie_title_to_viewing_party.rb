class AddMovieIdFromTmbdAndMovieTitleToViewingParty < ActiveRecord::Migration[7.1]
  def change
    add_column :viewing_parties, :movie_id_from_tmdb, :integer
    add_column :viewing_parties, :movie_title, :string
  end
end
