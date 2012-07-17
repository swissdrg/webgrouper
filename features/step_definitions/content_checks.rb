#Everything concerning checking content that should be/should not be shown on the page
Then /^the result should be shown$/ do
  step %{I should see "0" in "grouping"}
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^(?:|I )should see "([^"]*)" in "([^"]*)"$/ do |text, field|
  find(:css, 'fieldset#' + field). should have_content(text)
end

Then /^(?:|I )should see "([^"]*)" in result$/ do |text|
  find(:css, 'fieldset#grouping').should have_content?(text)
end

Then /^I should see (\d+) diagnoses fields$/ do |field_count|
  field_count = field_count.to_i - 1
  page.should have_css("#webgrouper_patient_case_diagnoses_#{field_count}")
end

Then /^I should not see (\d+) diagnoses fields$/ do |field_count|
  field_count = field_count.to_i - 1
  page.should_not have_css("#webgrouper_patient_case_diagnoses_#{field_count}")
end

Then /^I should see (\d+) procedures fields$/ do |field_count|
  field_count = field_count.to_i - 1
  page.should have_css("#webgrouper_patient_case_procedures_#{field_count}_0")
end

Then /^I should not see (\d+) procedures fields$/ do |field_count|
  field_count = field_count.to_i - 1
  page.should_not have_css("#webgrouper_patient_case_procedures_#{field_count}_0")
end

Then /^the grouping should succeed$/ do
  page.should_not have_css('.errorflash')
end

Then /^the form should stay the same$/ do
  #TODO
end