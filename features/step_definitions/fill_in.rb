Given /^the form with initialized standard values$/ do
  visit root_path
end

When /^I enter some random \(valid!\) data$/ do
  step %{I fill in "webgrouper_patient_case_age" with "62"}
  step %{I fill in "webgrouper_patient_case_pdx" with "R560"}
end

When /^I press on "([^"]*)"$/ do |button|
  click_button(button)
end

Then /^the grouping should succeed$/ do
  
end

Then /^the result should be shown$/ do
  step %{I should see "(DRG: 960Z, MDC: 01, PCCL: 0)"}
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end