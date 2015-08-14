# encoding: UTF-8
require 'rails_helper'

RSpec.describe WebgrouperPatientCase, type: :feature do

  describe 'parse field' do
    it 'gives an error when submitting an empty form' do
      visit 'de/webgrouper_patient_cases/parse'
      find("input[type='submit']").click

      expect(find('span.error')).to have_content('muss ausgefüllt werden')
    end

    it 'should give an error when submitting a string with the wrong number of separating characters' do
      visit 'de/webgrouper_patient_cases/parse'
      fill_in 'webgrouper_patient_case_parsing[parse_string]',
              with: '123;40;0;4000;M;99;99;8;;0;S550;B373;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;6602;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'

      find("input[type='submit']").click

      expect(find('span.error')).to have_content('muss genau 209 Trennzeichen haben.')
    end

    it 'should give an error when submitting a string in pseudo bfs format' do
      visit 'de/webgrouper_patient_cases/parse'
      fill_in 'webgrouper_patient_case_parsing[parse_string]',
              with: 'test|atasf|asdf|'

      find("input[type='submit']").click

      expect(find('span.error')).to have_content('BFS Format erkannt. Bitte groupieren sie Dateien nur im SwissDRG Format.')
    end


    it 'should redirect to the correctly filled out form when submitting a valid string' do
      visit 'de/webgrouper_patient_cases/parse'
      fill_in 'webgrouper_patient_case_parsing[parse_string]',
              with: '123;40;0;4000;M;99;99;8;;0;S550;B373;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;6602;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'
      find("input[type='submit']").click

      expect(find_field('webgrouper_patient_case[pdx]').value).to eq('S55.0')
      expect(find_field('webgrouper_patient_case_diagnoses_0').value).to eq('B37.3')
      expect(find_field('webgrouper_patient_case_procedures_0_c').value).to eq('66.02')
    end

    it 'should redirect to the correctly filled out form when submitting a valid string separated with dashes' do
      visit 'de/webgrouper_patient_cases/parse'
      fill_in 'webgrouper_patient_case_parsing[parse_string]',
              with: '123-40-0-4000-M-99-99-8--0-S550-B373---------------------------------------------------------------------------------------------------6602---------------------------------------------------------------------------------------------------'
      find("input[type='submit']").click

      expect(find_field('webgrouper_patient_case[pdx]').value).to eq('S55.0')
      expect(find_field('webgrouper_patient_case_diagnoses_0').value).to eq('B37.3')
      expect(find_field('webgrouper_patient_case_procedures_0_c').value).to eq('66.02')
    end

    it 'should fill in additional fields from the id column' do
      visit 'de/webgrouper_patient_cases/parse'
      fill_in 'webgrouper_patient_case_parsing[parse_string]',
              with: '11_01.08.2015_07.08.2015_09.08.2015_1-0-6-3000-M-99-99-1--0-S550-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
      find("input[type='submit']").click
      expect(find_field('webgrouper_patient_case[entry_date]').value).to eq('07.08.2015')
      expect(find_field('webgrouper_patient_case[exit_date]').value).to eq('09.08.2015')
      expect(find_field('webgrouper_patient_case[birth_date]').value).to eq('01.08.2015')
      expect(find_field('webgrouper_patient_case[leave_days]').value).to eq('1')
      expect(find_field('webgrouper_patient_case[system_id]').value).to eq('11')
    end

    it 'should use the selected system' do
      visit 'de/webgrouper_patient_cases/parse'
      fill_in 'webgrouper_patient_case_parsing[parse_string]',
              with: '123-0-6-3000-M-99-99-1--0-S550-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
      select('v4.0 Planungsversion 1: 2013/2015', from: 'webgrouper_patient_case_parsing[system_id]')
      find("input[type='submit']").click
      expect(find_field('webgrouper_patient_case[system_id]').value).to eq('20')
    end

    it 'should use the selected house' do
      visit 'de/webgrouper_patient_cases/parse'
      fill_in 'webgrouper_patient_case_parsing[parse_string]',
              with: '123-0-6-3000-M-99-99-1--0-S550-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
      select('Geburtshaus', from: 'webgrouper_patient_case_parsing[house]')
      find("input[type='submit']").click
      expect(find_field('webgrouper_patient_case[house]').value).to eq('2')
    end
  end
end