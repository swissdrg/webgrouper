Given /^the form with initialized standard values$/ do
  visit root_path
end

When /^I enter some random \(valid!\) data$/ do
  step %{I fill in "webgrouper_patient_case_age" with "62"}
  step %{I fill in "webgrouper_patient_case_pdx" with "R560"}
end

When /^I enter "([^"]*)" as diagnosis$/ do |pdx|
  step %{I fill in "webgrouper_patient_case_pdx" with "#{pdx}"}
end

When /^I enter "([^"]*)" as procedure$/ do |proc|
  step %{I fill in "webgrouper_patient_case_procedures_0_0" with "#{proc}"}
end


When /^I enter "([^"]*)" as los$/ do |los|
  step %{I fill in "webgrouper_patient_case_los" with "#{los}"}
end

When /^I enter Transfered \(los more than 24 hours\) as admission mode$/ do 
  select(I18n.t('simple_form.options.webgrouper_patient_case.adm.adm11'), 
         :from => 'webgrouper_patient_case_adm')
end

When /^I press on "([^"]*)"$/ do |button|
  click_button(button)
end

Then /^the grouping should succeed$/ do
  page.should_not have_content "Fehler"
end

Then /^the result should be shown$/ do
  step %{I should see "B75B" in "grouping"}
  step %{I should see "01" in "grouping"}
  step %{I should see "0" in "grouping"}
end

Then /^the form should stay the same$/ do
  
  
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^(?:|I )should see "([^"]*)" in "([^"]*)"$/ do |text, field|
  find(:css, 'fieldset#' + field). should have_content(text)
end

Then /^(?:|I )should see "([^"]*)" in result$/ do |text|
  find(:css, 'fieldset#grouping').should have_content?(text)
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end