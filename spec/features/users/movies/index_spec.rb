require 'rails_helper'

RSpec.describe 'Find movies', type: :feature do
  before(:each) do
    @user = create(:user)
    @response = {
      "page"=>1,
      "results"=>
      [{"adult"=>false,
        "backdrop_path"=>"/zfbjgQE1uSd9wiPTX4VzsLi0rGG.jpg",
        "genre_ids"=>[18, 80],
        "id"=>278,
        "original_language"=>"en",
        "original_title"=>"The Shawshank Redemption",
        "overview"=>"Imprisoned in the 1940s for the double murder of his wife...",
        "popularity"=>161.739,
        "poster_path"=>"/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
        "release_date"=>"1994-09-23",
        "title"=>"The Shawshank Redemption",
        "video"=>false,
        "vote_average"=>8.705,
        "vote_count"=>26410
      }]
    }

    visit discover_user_path(@user)
  end

  describe 'When a user chooses to find top rated movies' do
    it 'They see a list of the 20 top rated movies sorted by ranking' do
      expect(page).to have_link("Find Top Rated Movies", href: "/users/#{@user.id}/movies")

      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v2.9.2'
        }).
      to_return(status: 200, body: @response.to_json)

      click_link 'Find Top Rated Movies'

      expect(page).to have_link("Discover Movies", href: discover_user_path(@user))
      expect(page).to have_content("The Shawshank Redemption")
      expect(page).to have_content("Vote Average: 8.705")
    end
  end
  
  describe 'When a user searches for a movie using a query' do
    it 'They see a list of the first 20 movies containing that query' do
      expect(page).to have_selector("input[type='text'][name='query']")
      expect(page).to have_selector("input[type='submit'][value='Find Movies']")

      stub_request(:get, "https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page=1&query=shawshank").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v2.9.2'
        }).
      to_return(status: 200, body: @response.to_json)

      find("input[type='text'][name='query']").set('shawshank')
      click_button 'Find Movies'

      expect(page).to have_link("Discover Movies", href: discover_user_path(@user))
      expect(page).to have_content("The Shawshank Redemption")
      expect(page).to have_content("Vote Average: 8.705")
    end
  end
end
