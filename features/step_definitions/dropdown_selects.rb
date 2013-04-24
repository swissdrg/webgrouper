# All steps concerning dropdown-selects
When /^I select "(.*?)" as system$/ do |system|
  step %{I select in "webgrouper_patient_case_system_id" "#{system}"}
end 

When /^I enter Transfered \(los more than 24 hours\) as admission mode$/ do 
  select(I18n.t('simple_form.options.webgrouper_patient_case.adm.adm11'), 
         :from => 'webgrouper_patient_case_adm')
end

# Needs the @javascript annotation
When /^I select "([^"]*)" as age mode$/ do |age_mode|
  age_mode_string = I18n.t('simple_form.options.webgrouper_patient_case.age_mode_decoy.' + age_mode)
  step %{I select in "webgrouper_patient_case_age_mode_decoy" "#{age_mode_string}"}
end

When /^I select "([^"]*)" as sep mode$/ do |sep|
  #fix for string parsing:
  if sep.eql? "01"
    sep = "00"
  end
  string = I18n.t('simple_form.options.webgrouper_patient_case.sep.sep' + sep)
  step %{I select in "webgrouper_patient_case_sep" "#{string}"}
end

When /^I select "([^"]*)" as adm mode$/ do |adm|
  string = I18n.t('simple_form.options.webgrouper_patient_case.adm.adm' + adm)
  step %{I select in "webgrouper_patient_case_adm" "#{string}"}
end

#Takes M, F or U as Gender
When /^I select "([^"]*)" as sex$/ do |sex|
  #Fix for parsing strings:
  if sex.eql? "2"
    sex = "U"
  end
  sexString = I18n.t('simple_form.options.webgrouper_patient_case.sex.' + sex)
  step %{I select in "webgrouper_patient_case_sex" "#{sexString}"}
end

When /^I select birthhouse as care taker$/ do
  step %{I select in "webgrouper_patient_case_house" "Geburtshaus"}
end

# General:

When /^(?:|I )select in "([^"]*)" "([^"]*)"$/ do |field, value|
  select(value, :from => field)
end