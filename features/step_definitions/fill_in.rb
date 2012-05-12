Given /^the form with initialized standard values$/ do
  visit "http://localhost:3000/de/webgrouper_patient_cases"
end

When /^I parse "([^"]*)" as input for the form$/ do |caseString|
  caseArray = caseString.split(";")
  if (!caseArray[1].blank?)
    step %{I enter "#{caseArray[1]}" as age}
    step %{I select "years" as age mode}
  else
    step %{I enter "#{caseArray[2]}" as age}
    step %{I select "days" as age mode}
    step %{I enter "#{caseArray[3]}" as admission weight}
  end
  step %{I select "#{caseArray[4]}" as sex}
  step %{I enter "#{caseArray[7]}" as los}
  step %{I enter "#{caseArray[8]}" as hmv}
  step %{I enter "#{caseArray[9]}" as diagnosis}
  step %{I enter "#{caseArray[10]}" as secondary diagnosis}
  step %{I submit the form}
end

When /^I select "([^"]*)" as age mode$/ do |age_mode|
  age_mode_string = I18n.t('simple_form.options.webgrouper_patient_case.age_mode.' + age_mode)
  step %{I select in "webgrouper_patient_case_age_mode" "#{age_mode_string}"}
end

When /^I enter "([^"]*)" as age$/ do |age|
  step %{I fill in "webgrouper_patient_case_age" with "#{age}"}
end

When /^I enter "([^"]*)" as hmv$/ do |hmv|
  step %{I fill in "webgrouper_patient_case_hmv" with "#{hmv}"}
end

When /^I enter "([^"]*)" as diagnosis$/ do |pdx|
  step %{I fill in "webgrouper_patient_case_pdx" with "#{pdx}"}
end

#Takes M, F or U as Gender
When /^I select "([^"]*)" as sex$/ do |sex|
  sexString = I18n.t('simple_form.options.webgrouper_patient_case.sex.' + sex)
  step %{I select in "webgrouper_patient_case_sex" "#{sexString}"}
end


When /^I enter "([^"]*)" as admission weight$/ do |adm_weight|
  step %{I fill in "webgrouper_patient_case_adm_weight" with "#{adm_weight}"}
end

When /^I enter "([^"]*)" as secondary diagnosis$/ do |diag|
  #(0..4).each do |field|
    step %{fill in "webgrouper_patient_case_diagnoses_0" with "#{diag}"}
  #end
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

When /^I press on "([^\"]*)"$/ do |button|
  click_button(button)
end

When /^I follow "([^\"]*)"$/ do |link|
  click_link(link)
end

Then /^the grouping should succeed$/ do
  page.should_not have_content "Fehler"
end

Then /^the result should be shown$/ do
  step %{I should see "0" in "grouping"}
end

When /^I enter some random \(valid!\) data$/ do
  step %{I enter "32" as age}
  step %{I enter "B36.1" as diagnosis}
end


Then /^the form should stay the same$/ do
  
  
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
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

When /^(?:|I )select in "([^"]*)" "([^"]*)"$/ do |field, value|
  select(value, :from => field)
end

When /^I submit the form$/ do
  step %{I press on "Fall Gruppieren"}
end
