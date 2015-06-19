require 'rails_helper'

RSpec.describe 'submitting a tarpsy patient case', type: :feature do

  it 'gives an error when submitting the default form' do
    visit 'de/tarpsy_patient_cases/new'
    find("input[type='submit']").click

    expect(page).to have_css 'div.errorflash'
    expect(find('div.errorflash')).to have_content('Hauptdiagnose')
  end

  it 'computes length of stay automatically from entry and exit date', js: true do
    visit 'http://localhost:3000/de/tarpsy_patient_cases/new'
    fill_in 'tarpsy_patient_case[entry_date]', with: '11.1.2013'
    fill_in 'tarpsy_patient_case[exit_date]', with: '15.1.2013'
    expect(find_field('tarpsy_patient_case[los]').value).to eq('5')
  end

end