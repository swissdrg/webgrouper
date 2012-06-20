Given /^the form with initialized standard values$/ do
  visit "http://localhost:3000/de/webgrouper_patient_cases"
end

# Needs the @javascript annotation
When /^I parse "([^"]*)" as input for the form$/ do |caseString|
  caseArray = caseString.split(";")
  if (!caseArray[1].blank? && !(caseArray[1].eql? "0"))
    step %{I enter "#{caseArray[1]}" as age}
    step %{I select "years" as age mode}
  else
    step %{I enter "#{caseArray[2]}" as age}
    step %{I select "days" as age mode}
    step %{I enter "#{caseArray[3]}" as admission weight}
  end
  step %{I select "#{caseArray[4]}" as sex}
  step %{I select "#{caseArray[5]}" as adm mode}
  step %{I select "#{caseArray[6]}" as sep mode}
  step %{I enter "#{caseArray[7]}" as los}
  #todo: same_day flag: 8
  step %{I enter "#{caseArray[9]}" as hmv}
  step %{I enter "#{caseArray[10]}" as diagnosis}
  
  field_index = 0
  pos = pos_last_value(caseArray, 11, 100)
  (11..pos).each do |nr|
    if caseArray.length > nr
      step %{I add more "diagnoses" fields} if field_index != 0 && field_index % 5 == 0
      step %{fill in "webgrouper_patient_case_diagnoses_#{field_index}" with "#{caseArray[nr]}"}
      field_index = field_index + 1
    end
  end
  #Only add procedures if there are actually any
  if caseArray.length > 108
    procs = "\"#{caseArray[108]}\""
    (109...caseArray.length).each do |nr|
      procs = "#{procs}, \"#{caseArray[nr]}\""
    end
    step %{I enter the procedures #{procs}}
  end
  step %{I submit the form}
  
end

def pos_last_value(array, first_pos, last_pos)
  pos_last_value = last_pos
  (0..(last_pos-first_pos)).each do |value|
    if array[last_pos - value].blank?
      pos_last_value = last_pos - value
    else
      break
    end
  end 
  pos_last_value
end

# Needs the @javascript annotation
When /^I enter the secondary diagnoses (".+")$/ do |diagnoses|
  diagnoses = diagnoses.scan(/"([^"]*?)"/).flatten
  (0..diagnoses.count).each do |field_index|
    step %{I add more "diagnoses" fields} if field_index != 0 && field_index % 5 == 0
    step %{fill in "webgrouper_patient_case_diagnoses_#{field_index}" with "#{diagnoses[field_index]}"}
  end
end

# Needs the @javascript annotation
When /^I enter the secondary diagnoses "([^"]*)" (\d+) times$/ do |code, count|
  (0..count.to_i - 1).each do |field_index|
    step %{I add more "diagnoses" fields} if field_index != 0 && field_index % 5 == 0
    step %{fill in "webgrouper_patient_case_diagnoses_#{field_index}" with "#{code}"}
  end
end

# Needs the @javascript annotation
When /^I enter the procedures "([^"]*)" (\d+) times$/ do |code, count|
  (0..(count.to_i - 1)).each do |field_index|
    step %{I add more "procedures" fields} if field_index != 0 && field_index % 3 == 0
    step %{fill in "webgrouper_patient_case_procedures_#{field_index}_0" with "#{code}"}
  end
end

# Needs the @javascript annotation
When /^I add more "([^"]*)" fields$/ do |kind|
  step %{I follow "add_#{kind}"}
end

# Needs the @javascript annotation
When /^I add the maximum number of "([^"]*)" fields$/ do |kind|
  while (page.has_selector?("a#add_#{kind}")) do
    step %{I add more "#{kind}" fields}
  end
end

# Needs the @javascript annotation
When /^I enter the procedures (".+")$/ do |procedures|
  procedures = procedures.scan(/"([^"]*?)"/).flatten
  (0..procedures.count).each do |field_index|
    step %{I add more "procedures" fields} if field_index != 0 && field_index % 3 == 0
    step %{fill in "webgrouper_patient_case_procedures_#{field_index}_0" with "#{procedures[field_index]}"}
  end
end

# Needs the @javascript annotation
When /^I enter the procedures with seitigkeit and date (".+")$/ do |procedures|
  procedures = procedures.scan(/"([^"]+?)"/).flatten
  (0..procedures.count-1).each do |field_index|
    procedure = procedures[field_index-1]
    procedure_parts = procedure.split(":")
    step %{I add more "procedures" fields} if field_index != 0 && field_index % 3 == 0
    step %{fill in "webgrouper_patient_case_procedures_#{field_index}_0" with "#{procedure_parts[0]}"}
    step %{I select in "webgrouper_patient_case_procedures_#{field_index}_1" "#{procedure_parts[1]}"}
    step %{fill in "webgrouper_patient_case_procedures_#{field_index}_2" with "#{procedure_parts[2]}"}
  end
end



When /^I press on "([^"]*)"$/ do |button|
  click_button(button)
end

When /^I follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^the grouping should succeed$/ do
  page.should_not have_selector('.errorflash')
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



When /^I submit the form$/ do
  step %{I press on "Fall Gruppieren"}
end
