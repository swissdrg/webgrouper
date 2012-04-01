Given /^the form with initialized standard values$/ do
  visit root_path
end

When /^I enter some random \(valid!\) data$/ do
  step %{I fill in "webgrouper_patient_case_age" with "62"}
  step %{I fill in "webgrouper_patient_case_pdx" with "R560"}
end

When /^I enter "([^"]*)" as diagnosis$/ do |pdx|
  step %{I fill in "webgrouper_patient_case_pdx" with "pdx"}
end


When /^I press on "([^"]*)"$/ do |button|
  click_button(button)
end

Then /^the grouping should succeed$/ do
  
end

Then /^the result should be shown$/ do
  step %{I should see "B75B" in result}
  step %{I should see "01" in result}
  step %{I should see "0" in result}
end

Then /^(?:|I )should see "([^"]*)" in result$/ do |text|
  if page.respond_to? :should
    within("fieldset#result") do
      has_content? text
    end
  else
    assert page.has_content?(text)
  end
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end