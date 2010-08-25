module CommandTest
  module Adapters
    module TestUnit
      module Assertions
        #
        # Passes if the block runs the given command.
        #
        #     assert_runs_command 'convert', 'evil.gif', 'good.png' do
        #       ...
        #     end
        #
        # Commands are matched according to CommandTest.match? .
        #
        def assert_runs_command(*expected, &block)
          result = Tests::RunsCommand.new(expected, &block)
          matches = result.matches?
          assert_block(matches ? nil : result.positive_failure_message) do
            matches
          end
        end

        #
        # Passes if the block does not run the given command.
        #
        #     assert_does_not_run_command 'convert', 'evil.gif', 'good.png' do
        #       ...
        #     end
        #
        # Commands are matched according to CommandTest.match? .
        #
        def assert_does_not_run_command(*expected, &block)
          result = Tests::RunsCommand.new(expected, &block)
          matches = result.matches?
          assert_block(matches ? result.negative_failure_message : nil) do
            !matches
          end
        end
      end

      ::Test::Unit::TestCase.send :include, Assertions
    end
  end
end
