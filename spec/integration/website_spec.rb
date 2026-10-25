require 'spec_helper'

describe 'Website', :js, type: :feature do
  it 'loads the content-versioned logo after a reload' do
    visit '/help.html'
    page.refresh

    expect(page).to have_css('img[src^="/img/icon.png?v="]') do |image|
      image.evaluate_script('this.complete && this.naturalWidth > 0')
    end
  end
end
