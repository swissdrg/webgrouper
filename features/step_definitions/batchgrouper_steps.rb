Given /^the batchgrouper with initialized standard values$/ do
  if Rails.env == "development"
    visit "http://localhost:8080/webgrouper/de/batchgrouper"
  else
    visit "http://77.95.120.68:8080/webgrouper/de/batchgrouper"
  end
end

When /^I attach a file called "(.*?)"$/ do |arg1|
  attach_file("batchgrouper_file", File.join(Rails.root, "features", arg1))
end

Then /^I should receive a file named "(.*?)"$/ do |arg1|
   page.response_headers['Content-Disposition'].should include("filename=\"#{arg1}\"")
end

Then /^the MD(\d+)sum of it should be "(.*?)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end
