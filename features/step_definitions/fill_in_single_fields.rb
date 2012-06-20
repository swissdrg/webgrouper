# All steps concerning filling in information in the fields (without dropdown selection)

When /^I enter "([^"]*)" as age$/ do |age|
  step %{I fill in "webgrouper_patient_case_age" with "#{age}"}
end

When /^I enter "([^"]*)" as hmv$/ do |hmv|
  step %{I fill in "webgrouper_patient_case_hmv" with "#{hmv}"}
end

When /^I enter "([^"]*)" as diagnosis$/ do |pdx|
  step %{I fill in "webgrouper_patient_case_pdx" with "#{pdx}"}
end

When /^I enter "([^"]*)" as los$/ do |los|
  step %{I fill in "webgrouper_patient_case_los" with "#{los}"}
end

When /^I enter "([^"]*)" as admission weight$/ do |adm_weight|
  step %{I fill in "webgrouper_patient_case_adm_weight" with "#{adm_weight}"}
end

# Needs the @javascript annotation
When /^I enter "([^"]*)" as procedure$/ do |proc|
  step %{I fill in "webgrouper_patient_case_procedures_0_0" with "#{proc}"}
end

# Needs the @javascript annotation
When /^I enter "([^"]*)" as secondary diagnosis$/ do |diagnosis|
  step %{fill in "webgrouper_patient_case_diagnoses_0" with "#{diagnosis}"}
end

# general:

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end
