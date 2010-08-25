Given /^I have a file "(.*?)" containing:$/ do |file_name, content|
  path = "#{TMP}/#{file_name}"
  open(path, 'w'){|f| f.print content}
end

When /^I run "(.*?)" on "(.*?)"$/ do |command, file_name|
  Dir.chdir ROOT do
    @output = `#{command} #{TMP}/#{file_name} 2>&1`
  end
end

Then /^the output should contain "(.*?)"$/ do |fragment|
  @output.should include(fragment)
end

Then /^the output should contain:$/ do |fragment|
  @output.should include(fragment)
end

Then /^the output should contain in this order$/ do |table|
  table.raw.inject(0) do |index, row|
    index && @output.index(row.first, index)
  end.should_not be_nil
end
