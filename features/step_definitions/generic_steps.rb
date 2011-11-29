When /^"([^\"]*)" is fixed$/ do |what|
  puts "\nDEFERRED (#{what})"
end

Then /^pause for (\d+) seconds$/ do |seconds|
  sleep seconds.to_i
end

# we want greedy matching for this one so we can handle tags that have attributes in them
Then /^I should see the text with tags ["'](.*)["']$/ do |text|
  page.body.should =~ /#{text}/m
end

Then /^I should not see the text with tags ['"](.*)['"]$/ do |text|
  page.body.should_not =~ /#{text}/m
end


