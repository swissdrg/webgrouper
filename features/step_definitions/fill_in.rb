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

When /^I enter "([^"]*)" as los$/ do |los|
  step %{I fill in "webgrouper_patient_case_los" with "#{los}"}
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

Then /^show me the results$/ do
  save_and_open_page
end

Then /^(?:|I )should see "([^"]*)" in "([^"]*)"$/ do |text, field|
  within(:css, 'fieldset#' + field) do
    has_content?(text)
  end
end

Then /^(?:|I )should see "([^"]*)" in result$/ do |text|
  within(:css, 'fieldset#grouping') do
    has_content?(text)
  end
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end