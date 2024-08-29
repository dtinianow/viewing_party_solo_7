require 'rails_helper'

RSpec.describe 'Find viewing party', type: :feature do
  before(:each) do
    @user = create(:user)
    @viewing_party = create(:viewing_party)
    UserParty.create!(user: @user, viewing_party: @viewing_party, host: true)

    @watch_providers = {
      'results' => {
        'US' => {
          'buy' =>
            [{ 'logo_path' => '/9ghgSC0MA082EL6HLCW3GalykFD.jpg',
               'provider_id' => 2,
               'provider_name' => 'Apple TV',
               'display_priority' => 4 }],
          'rent' =>
          [{ 'logo_path' => '/8z7rC8uIDaTM91X0ZfkRf04ydj2.jpg',
             'provider_id' => 3,
             'provider_name' => 'Google Play Movies',
             'display_priority' => 16 }]
        }
      }
    }
  end

  describe 'When a user visits a viewing party show page' do
    it 'They see details about the viewing party and images representing watch providers' do
      stub_request(:get, "https://api.themoviedb.org/3/movie/#{@viewing_party.movie_id_from_tmdb}/watch/providers")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Faraday v2.9.2'
          }
        )
        .to_return(status: 200, body: @watch_providers.to_json, headers: {})

      visit user_movie_viewing_party_path(@user, @viewing_party.movie_id_from_tmdb, @viewing_party)

      expect(page).to have_link("#{@user.name}'s Dashboard", href: "/users/#{@user.id}")
      expect(page).to have_content(@viewing_party.movie_title)
      expect(page).to have_content("Start Time:")
      expect(page).to have_content(@viewing_party.start_time)
      expect(page).to have_content("Date:")
      expect(page).to have_content(@viewing_party.date)
      expect(page).to have_content('Buy')
      expect(page).to have_css(".buy-providers img[src=\"#{TMDB_IMAGE_URL}#{@watch_providers['results']['US']['buy'].first['logo_path']}\"]")
      expect(page).to have_content('Rent')
      expect(page).to have_css(".rent-providers img[src=\"#{TMDB_IMAGE_URL}#{@watch_providers['results']['US']['rent'].first['logo_path']}\"]")
    end
  end
end
