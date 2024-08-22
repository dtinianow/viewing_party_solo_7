FactoryBot.define do
  factory :viewing_party do
    duration { 3 }
    date { '7/5/2024' }
    start_time { '5 PM' }
    movie_id_from_tmdb { 240 }
    movie_title { 'The Godfather Part II' }
  end
end