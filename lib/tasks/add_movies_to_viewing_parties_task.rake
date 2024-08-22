namespace :viewing_parties do
  desc 'Add movie data to viewing parties with no associated movie'
  task add_movies_to_party: :environment do
    ViewingParty.where(movie_id_from_tmdb: nil).each do |party|
      party.update(movie_id_from_tmdb: 240, movie_title: 'The Godfather Part II')
      puts "Updating Viewing Party #{party.id}"
    end
  end
end
