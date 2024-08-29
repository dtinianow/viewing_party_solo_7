require 'rails_helper'

RSpec.describe 'Find movie', type: :feature do
  before(:each) do
    @user = create(:user)
    @movie = { 'adult' => false,
               'backdrop_path' => '/zfbjgQE1uSd9wiPTX4VzsLi0rGG.jpg',
               'belongs_to_collection' => nil,
               'budget' => 25_000_000,
               'genres' =>
      [{ 'id' => 18, 'name' => 'Drama' }, { 'id' => 80, 'name' => 'Crime' }],
               'homepage' => '',
               'id' => 278,
               'imdb_id' => 'tt0111161',
               'origin_country' => ['US'],
               'original_language' => 'en',
               'original_title' => 'The Shawshank Redemption',
               'overview' =>
      'Imprisoned in the 1940s for the double murder of his wife and her lover...',
               'popularity' => 177.394,
               'poster_path' => '/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg',
               'production_companies' =>
      [{ 'id' => 97,
         'logo_path' => '/7znWcbDd4PcJzJUlJxYqAlPPykp.png',
         'name' => 'Castle Rock Entertainment',
         'origin_country' => 'US' }],
               'production_countries' =>
      [{ 'iso_3166_1' => 'US', 'name' => 'United States of America' }],
               'release_date' => '1994-09-23',
               'revenue' => 28_341_469,
               'runtime' => 142,
               'spoken_languages' =>
      [{ 'english_name' => 'English',
         'iso_639_1' => 'en',
         'name' => 'English' }],
               'status' => 'Released',
               'tagline' => 'Fear can hold you prisoner. Hope can set you free.',
               'title' => 'The Shawshank Redemption',
               'video' => false,
               'vote_average' => 8.706,
               'vote_count' => 26_447 }

    @cast = {
      'id' => 278,
      'cast' =>
     [{ 'adult' => false,
        'gender' => 2,
        'id' => 504,
        'known_for_department' => 'Acting',
        'name' => 'Tim Robbins',
        'original_name' => 'Tim Robbins',
        'popularity' => 15.67,
        'profile_path' => '/djLVFETFTvPyVUdrd7aLVykobof.jpg',
        'cast_id' => 3,
        'character' => 'Andy Dufresne',
        'credit_id' => '52fe4231c3a36847f800b131',
        'order' => 0 }]
    }

    @reviews = {
      'id' => 278,
      'page' => 1,
      'results' =>
     [{ 'author' => 'tmdb73913433',
        'author_details' =>
        { 'name' => '',
          'username' => 'tmdb73913433',
          'avatar_path' => nil,
          'rating' => 6.0 },
        'content' =>
        'Make way for the best film ever made people. **Make way.**',
        'created_at' => '2017-11-11T15:09:34.114Z',
        'id' => '5a0712aec3a3687914014a4b',
        'updated_at' => '2021-06-23T15:58:02.682Z',
        'url' =>
        'https://www.themoviedb.org/review/5a0712aec3a3687914014a4b' }]
    }
  end

  describe 'When a user visits a movie page' do
    it 'They see details about that movie, the cast, and reviews' do
      stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie['id']}?language=en-US")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Faraday v2.9.2'
          }
        )
        .to_return(status: 200, body: @movie.to_json)

      stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie['id']}/credits?language=en-US")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Faraday v2.9.2'
          }
        )
        .to_return(status: 200, body: @cast.to_json)

      stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie['id']}/reviews?language=en-US&page=1")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Faraday v2.9.2'
          }
        )
        .to_return(status: 200, body: @reviews.to_json)

      visit user_movie_path(@user, @movie['id'])

      expect(page).to have_link('Create Viewing Party')
      expect(page).to have_content(@movie['title'])
      expect(page).to have_content("Vote: #{@movie['vote_average']}")
      expect(page).to have_content('Runtime: 2 hr and 22 min')
      expect(page).to have_content('Genre: Drama, Crime')
      expect(page).to have_content('Summary')
      expect(page).to have_content(@movie['overview'].to_s)
      expect(page).to have_content('Cast')
      expect(page).to have_content(@cast['cast'].first['name'].to_s)
      expect(page).to have_content(@cast['cast'].first['character'].to_s)
      expect(page).to have_content("#{@reviews['results'].count} Reviews")
      expect(page).to have_content(@reviews['results'].first['author'])
      expect(page).to have_content(@reviews['results'].first['content'])
    end
  end
end
