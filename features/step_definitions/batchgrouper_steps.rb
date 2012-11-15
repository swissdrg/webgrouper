Given /^the batchgrouper with initialized standard values$/ do
  context = ""
  if Rails.env == "test"
    visit "http://localhost:8080"+ context + "/de/batchgrouper"
  else
    visit "http://77.95.120.68:8080" + context + "/de/batchgrouper"
  end
end

When /^I attach a file called "(.*?)"$/ do |arg1|
  attach_file("batchgrouper_file", File.join(Rails.root, "features", arg1))
end

Then /^I should receive a file called "(.*?)"$/ do |arg1|
   page.response_headers['Content-Disposition'].should include("filename=\"#{arg1}\"")
end

Then /^the MD5sum of it should be "(.*?)"$/ do |arg2|
  hash = Digest::MD5.hexdigest(page.source)
  hash.to_s.should == arg2
end