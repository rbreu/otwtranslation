When /^"([^\"]*)" is fixed$/ do |what|
  puts "\nDEFERRED (#{what})"
end

Then /^pause for (\d+) seconds$/ do |seconds|
  sleep seconds.to_i
end
