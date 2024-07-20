require 'rails_helper'

RSpec.describe 'Discover movies', type: :feature do
  describe 'When a user visits the discover movie page' do
    it 'They see a movie search bar and a link to find top rated movies' do
      user = create(:user)

      visit discover_user_path(user)

      expect(page).to have_link("Find Top Rated Movies", href: "/users/#{user.id}/movies")
      expect(page).to have_selector("input[type='text'][name='query']")
      expect(page).to have_selector("input[type='submit'][value='Find Movies']")
    end
  end
end
