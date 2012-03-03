When /^I do shelr (.*)$/ do |shelr_step|
  begin
    step(shelr_step)
  rescue => e
    @shelr_exception = e
  end
end

# Useful for debugging timing problems
When /^sleep (\d+)$/ do |time|
  sleep time.to_i
end

Given /^shelr backend is (\w+)$/ do |backend|
  step "I run `shelr backend #{backend}`"
end

When /^I set env variable "(\w+)" to "([^"]*)"$/ do |var, value|
  ENV[var] = value
end

Then /^aruba should fail with "([^"]*)"$/ do |error_message|
  @shelr_exception.message.should include(unescape(error_message))
end

Then /^the following step should fail with Spec::Expectations::ExpectationNotMetError:$/ do |multiline_step|
  proc { steps multiline_step }.should raise_error(RSpec::Expectations::ExpectationNotMetError)
end

Then /^the output should be (\d+) bytes long$/ do |length|
  all_output.chomp.length.should == length.to_i
end

When /^show me the output$/ do

  require 'pp'
  pp all_output
end
