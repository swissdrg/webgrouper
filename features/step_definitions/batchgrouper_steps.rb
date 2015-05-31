Given /^the batchgrouper with initialized standard values$/ do
  if Rails.env == "test"
    visit "http://localhost:3000/de/batchgrouper"
  else
    visit "http://webgrouper.swissdrg.org/de/batchgrouper"
  end
  step %{I select system 9}
end

BATCHGROUPER_TESTFILES_ROOT = File.join(Rails.root, "test", 'batchgrouper_testfiles')

When /^I attach a file called "(.*?)"$/ do |arg1|
  attach_file("batchgrouper_file", File.join(BATCHGROUPER_TESTFILES_ROOT, arg1))
end

Then /^I should receive a file called "(.*?)"$/ do |arg1|
   page.response_headers['Content-Disposition'].should include("filename=\"#{arg1}\"")
end

Then /^the MD5sum of it should be "(.*?)"$/ do |arg2|
  hash = Digest::MD5.hexdigest(page.source)
  expect(hash).to eq(arg2)
end

Then /^the MD5sum of it should be the same as from the precomputed result for system (\d+b?)$/ do |system_id|
  hash = Digest::MD5.hexdigest(page.source)
  expected = Digest::MD5.hexdigest(File.read(File.join(BATCHGROUPER_TESTFILES_ROOT, "testdaten_#{system_id}.csv.out")))
  expect(hash).to eq(expected)
end
