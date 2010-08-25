module CommandTest
  module RSpec
    module Matchers
      #
      # Matches if the proc runs the given command.
      #
      #     lambda do
      #       ...
      #     end.should run_command('convert', 'evil.gif', 'good.png')
      #
      # Commands are matched according to CommandTest.match? .
      #
      def run_command(*command)
        RunCommand.new(command)
      end
    end

    class RunCommand
      def initialize(expected)
        @expected = expected
      end

      def matches?(proc)
        @test = Tests::RunsCommand.new(@expected, &proc)
        @test.matches?
      end

      def failure_message_for_should
        @test.positive_failure_message
      end

      def failure_message_for_should_not
        @test.negative_failure_message
      end
    end

    ::Spec::Runner.configure do |config|
      config.send :include, Matchers
    end
  end
end
