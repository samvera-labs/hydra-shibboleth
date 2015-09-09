require 'spec_helper'

describe Hydra::Shibboleth do
  it 'has a version number' do
    expect(Hydra::Shibboleth::VERSION).not_to be nil
  end

  describe 'anonymous users' do
    it 'can view a public resource' do
      visit widgets_path
      expect(page).to have_text 'Listing widgets'
    end
    it 'cannot view a restricted resource' do
      visit new_widget_path
      expect(page).to have_text 'Not authorized'
    end
  end
  describe 'authorized users' do
    it 'can view a public resource' do
      sign_in_developer
      visit widget_path
      expect(page).to have_text 'Listing widgets'
    end
    it 'can view a restricted resource' do
      sign_in_developer
      visit new_widget_path
      expect(page).to have_text 'New widget'
    end
  end
end

def sign_in_developer
  visit '/users/sign_in'
  fill_in 'name', with: 'name'
  fill_in 'email', with: 'email@email.com'
  click_on 'Sign In'
end
