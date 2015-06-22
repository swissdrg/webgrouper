# encoding: utf-8
require 'rails_helper'

# TODO: cleanup batchgroupings after test.
RSpec.describe 'submitting a tarpsy batchgrouper query', type: :feature do

  it 'should render an error when submitting the default form' do
    visit 'de/tarpsy_batchgrouper_queries/new'
    find("input[type='submit']").click

    expect(page).to have_css 'div.errorflash'
    expect(find('div.errorflash')).to have_content('MB-Datensatz: muss ausgefüllt werden')
    expect(find('div.errorflash')).to have_content('HoNOS-Datensatz: muss ausgefüllt werden')
  end

  it 'should send a result when submitting two valid files' do
    visit 'de/tarpsy_batchgrouper_queries/new'
    attach_file 'tarpsy_batchgrouper_query[mb_input]', 'test/testdaten_mb.txt'
    attach_file 'tarpsy_batchgrouper_query[honos_input]', 'test/testdaten_ph.txt'
    find("input[type='submit']").click

    expect(page.response_headers['Content-Type']).to eq('text/csv')
  end

  it 'should show a download started hint when receiving the file', js: true do
    # Important: path must be specified with host.
    visit 'http://localhost:3000/de/tarpsy_batchgrouper_queries/new'
    attach_file 'tarpsy_batchgrouper_query[mb_input]', 'test/testdaten_mb.txt'
    attach_file 'tarpsy_batchgrouper_query[honos_input]', 'test/testdaten_ph.txt'
    find("input[type='submit']").click

    expect(page).to have_css 'div.info'
    expect(find('div#download_finished_hint')).to have_content('Download gestarted.')
    expected_str = 'Could not find patient cases with following FIDs: 17316, 17341, 17440, 17723, 18003, 18054, 18115, 18119, 18144, 18300, 18316, 18344, 18418, 18436, 18463, 18548, 18596, 18641, 18651, 18671, 18681, 18682, 18685, 18687, 18698, 18701, 18713, 18714, 18727, 18728, 18733, 18739, 18742, 18749, 18753'
    expect(find('div#additional_hint')).to have_content(expected_str)
  end

end