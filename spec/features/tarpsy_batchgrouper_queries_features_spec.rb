# encoding: utf-8
require 'rails_helper'

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


end