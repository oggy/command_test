Feature: RSpec Integration

  As a developer who uses RSpec
  I want to use Command Test
  So I can write beautiful tests

  Scenario: Using run_command
  Given I have a file "spec.rb" containing:
    """
    require 'command_test'

    describe "#run_command" do
      describe "when using should" do
        it "should pass if the command is run" do
          lambda do
            system 'sh', '-c', ''
          end.should run_command('sh', '-c', '')
        end

        it "should fail if the command is not run" do
          lambda do
            system 'sh', '-c', 'true'
          end.should run_command('sh', '-c', '')
        end
      end

      describe "when using should_not" do
        it "should pass if the command is not run" do
          lambda do
            system 'sh', '-c', 'true'
          end.should_not run_command('sh', '-c', '')
        end

        it "should fail if the command is run" do
          lambda do
            system 'sh', '-c', ''
          end.should_not run_command('sh', '-c', '')
        end
      end
    end
    """
  When I run "spec" on "spec.rb"
  Then the output should contain ".F.F"
  And the output should contain:
    """
    This command should have been run, but was not:
      "sh" "-c" ""
    These were the commands run:
      "sh" "-c" "true"
    """
  And the output should contain:
    """
    This command should not have been run, but was:
      "sh" "-c" ""
    These were the commands run:
      "sh" "-c" ""
    """
  And the output should contain in this order
    | This command should have been run, but was not |
    | This command should not have been run, but was |
