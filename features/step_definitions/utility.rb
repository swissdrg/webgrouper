
When /^I wait (\d+) seconds?$/ do |seconds|
  sleep seconds.to_i
end

Then /^show me the page$/ do
  save_and_open_page
end