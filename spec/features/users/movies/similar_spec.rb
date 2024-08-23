require 'rails_helper'

RSpec.describe 'Similar movies', type: :feature do
  before(:each) do
    @user = create(:user)
    @movie_id = 78
    @response = {
      'page' => 1,
      'results' =>
      [{ 'adult' => false,
         'backdrop_path' => '/zfbjgQE1uSd9wiPTX4VzsLi0rGG.jpg',
         'genre_ids' => [18, 80],
         'id' => 278,
         'original_language' => 'en',
         'original_title' => 'The Shawshank Redemption',
         'overview' => 'Imprisoned in the 1940s for the double murder of his wife...',
         'popularity' => 161.739,
         'poster_path' => '/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg',
         'release_date' => '1994-09-23',
         'title' => 'The Shawshank Redemption',
         'video' => false,
         'vote_average' => 8.705,
         'vote_count' => 26_410 }]
    }
  end

  describe 'When a user chooses to find similar movies' do
    it 'They see a list of similar movies' do
      stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}/similar?language=en-US&page=1")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Faraday v2.9.2'
          }
        )
        .to_return(status: 200, body: @response.to_json)

      visit similar_user_movie_path(@user, @movie_id)

      expect(page).to have_link('Discover Movies', href: discover_user_path(@user))
      expect(page).to have_content('Title:')
      expect(page).to have_content(@response['results'].first['title'])
      expect(page).to have_content('Release Date:')
      expect(page).to have_content(@response['results'].first['release_date'])
      expect(page).to have_content('Overview:')
      expect(page).to have_content(@response['results'].first['overview'])
      expect(page).to have_content('Poster:')
      expect(page).to have_css("img[src=\"#{TMDB_IMAGE_URL}#{@response['results'].first['poster_path']}\"]")
      expect(page).to have_content('Vote Average:')
      expect(page).to have_content(@response['results'].first['vote_average'])
    end
  end
end
