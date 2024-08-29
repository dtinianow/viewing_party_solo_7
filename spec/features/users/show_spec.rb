require 'rails_helper'

RSpec.describe 'User dashboard', type: :feature do
  describe 'When a user visits the path of a user at "users/:user_id' do
    it 'They see user\'s dashboard and a link to discover new movies' do
      @user = create(:user)

      visit user_path(@user)

      expect(page).to have_content("#{@user.name}'s Dashboard")
      expect(page).to have_link('Discover Movies', href: "/users/#{@user.id}/discover")
    end

    it 'They see all viewing parties that the user is hosting and it\s participants' do
      @host = create(:user)
      @guest = create(:user, name: 'Jane Smith')
      @party = create(:viewing_party)
      create(:user_party, user: @host, viewing_party: @party)
      create(:user_party, :guest, user: @guest, viewing_party: @party)

      visit user_path(@host)

      expect(page).to have_content 'Hosting'
      expect(page).to have_content("Who's Coming?")
      expect(page).to have_content("#{@guest.name}")
    end

    it 'They see all viewing parties that the user is not hosting but is attending' do
      @host = create(:user)
      @guest = create(:user, name: 'Jane Smith')
      @party = create(:viewing_party)
      create(:user_party, user: @host, viewing_party: @party)
      create(:user_party, :guest, user: @guest, viewing_party: @party)

      visit user_path(@guest)

      expect(page).to have_content("Host: #{@host.name}")
      expect(page).to have_content("Who's Coming?")
      expect(page).to have_content("#{@guest.name}")
    end
  end
end
