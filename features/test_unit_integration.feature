Feature: Test Unit Integration

  As a developer who uses Test::Unit
  I want to use Command Test
  So I can write beautiful tests

  Scenario: Using run_command
  Given I have a file "test.rb" containing:
    """
    require 'test/unit'
    require 'command_test'

    class CommandTests < Test::Unit::TestCase
      def test_assert_runs_command_passes_if_the_command_is_run
        assert_runs_command 'sh', '-c', '' do
          system 'sh', '-c', ''
        end
      end

      def test_assert_runs_command_fails_if_the_command_is_not_run
        assert_runs_command 'sh', '-c', '' do
          system 'sh', '-c', 'true'
        end
      end

      def test_assert_does_not_run_command_passes_if_the_command_is_not_run
        assert_does_not_run_command 'sh', '-c', '' do
          system 'sh', '-c', 'true'
        end
      end

      def test_assert_does_not_run_command_fails_if_the_command_is_run
        assert_does_not_run_command 'sh', '-c', '' do
          system 'sh', '-c', ''
        end
      end
    end
    """
  When I run "ruby -Ilib" on "test.rb"
  # Test::Unit sorts tests alphabetically.
  Then the output should contain "F.F."
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
    | This command should not have been run, but was |
    | This command should have been run, but was not |
