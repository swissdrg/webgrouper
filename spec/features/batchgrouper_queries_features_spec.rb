# encoding: utf-8
require 'rails_helper'

RSpec.describe 'submitting a batchgrouper query', type: :feature do

  it 'should render an error when submitting the default form' do
    visit 'de/batchgrouper_queries/new'
    find("input[type='submit']").click

    expect(page).to have_css 'div.field_with_errors'
    expect(find('span.error')).to have_content('muss ausgefüllt werden')
  end

  it 'should send a result when submitting two valid files' do
    visit 'de/batchgrouper_queries/new'
    attach_file 'batchgrouper_query[input]', 'test/data.in'
    find("input[type='submit']").click

    expect(page.response_headers['Content-Type']).to eq('text/csv')
  end


  it 'should render an error when trying to submit an image' do
    visit 'de/batchgrouper_queries/new'
    attach_file 'batchgrouper_query[input]', 'test/fail_image.jpeg'
    find("input[type='submit']").click

    expect(page).to have_css 'div.field_with_errors'
    expect(find('span.error')).to have_content('might not be a text file')
  end

  it 'should show a download started hint when receiving the file', js: true do
    # Important: path must be specified with host.
    visit 'http://localhost:3000/de/batchgrouper_queries/new'
    attach_file 'batchgrouper_query[input]', 'test/data.in'
    find("input[type='submit']").click

    expect(page).to have_css 'div.info'
    expect(find('div#download_finished_hint')).to have_content('Download gestarted.')
  end

end