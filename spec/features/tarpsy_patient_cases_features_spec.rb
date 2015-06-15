require 'rails_helper'

RSpec.describe 'submitting a tarpsy patient case', type: :feature do

  it 'gives an error when submitting the default form' do
    visit 'de/tarpsy_patient_cases/new'
    find("input[type='submit']").click

    expect(page).to have_css 'div.errorflash'
    expect(find('div.errorflash')).to have_content('Hauptdiagnose')
  end
end