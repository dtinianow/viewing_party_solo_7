require 'rails_helper'

RSpec.describe 'Create New Viewing Party', type: :feature do
  describe 'When user visits the new viewing parties route' do
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
    end

    it 'They can create a viewing party for the movie with no other users invited' do
      visit new_user_movie_viewing_party_path(@user, @movie['id'])

      expect(page).to have_content("Create a Party for #{@movie['title']}")
      expect(page).to have_link('Discover Movies', href: discover_user_path(@user))
      expect(ViewingParty.count).to eq(0)
      expect(UserParty.count).to eq(0)

      fill_in 'viewing_party[duration]', with: '180'
      fill_in 'viewing_party[date]', with: '07/21/2026'
      fill_in 'viewing_party[start_time]', with: '13:30'

      click_button 'Create Party'

      expect(ViewingParty.count).to eq(1)
      expect(UserParty.count).to eq(1)
      expect(page).to have_current_path(user_path(@user))
      expect(page).to have_content 'Party Time: 07/21/2026 at 13:30'
      expect(page).to have_content "Host: #{@user.name}"
      expect(page).to have_content "Who's Coming?"

      viewing_party = ViewingParty.first

      expect(viewing_party.users.count).to eq(1)
      expect(viewing_party.find_host).to eq(@user)
    end

    it 'They can create a viewing party for the movie with other users invited' do
      user2 = create(:user, name: 'Jane Smith')
      user3 = create(:user, name: 'Jack Doedoe')

      visit new_user_movie_viewing_party_path(@user, @movie['id'])

      expect(page).to have_content("Create a Party for #{@movie['title']}")
      expect(page).to have_link('Discover Movies', href: discover_user_path(@user))
      expect(ViewingParty.count).to eq(0)

      fill_in 'viewing_party[duration]', with: '180'
      fill_in 'viewing_party[date]', with: '07/21/2026'
      fill_in 'viewing_party[start_time]', with: '13:30'

      check('viewing_party[user_ids][]', option: user3.id)

      click_button 'Create Party'

      expect(ViewingParty.count).to eq(1)
      expect(page).to have_current_path(user_path(@user))
      expect(page).to have_content 'Party Time: 07/21/2026 at 13:30'
      expect(page).to have_content "Host: #{@user.name}"
      expect(page).to have_content "Who's Coming?"
      expect(page).to have_content user3.name
      expect(page).not_to have_content user2.name

      viewing_party = ViewingParty.first

      expect(viewing_party.users.count).to eq(2)
      expect(viewing_party.find_host).to eq(@user)
      expect(UserParty.count).to eq(2)
    end

    it 'They cannot create a viewing party with missing attributes' do
      visit new_user_movie_viewing_party_path(@user, @movie['id'])

      expect(ViewingParty.count).to eq(0)
      expect(UserParty.count).to eq(0)

      fill_in 'viewing_party[duration]', with: ''
      fill_in 'viewing_party[date]', with: ''
      fill_in 'viewing_party[start_time]', with: ''

      click_button 'Create Party'

      expect(ViewingParty.count).to eq(0)
      expect(page).to have_content 'There was a problem creating the viewing party'
    end
  end
end
