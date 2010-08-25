module CommandTest
  module Tests
    class RunsCommand
      def initialize(expected, &proc)
        @expected = expected
        @proc = proc
      end

      def matches?
        @actual = CommandTest.record(&@proc)
        @actual.any? do |actual|
          CommandTest.match?(@expected, actual)
        end
      end

      def positive_failure_message
        expected_string = display_commands([@expected])
        actual_string = display_commands(@actual)
        "This command should have been run, but was not:\n#{expected_string}\n" <<
          "These were the commands run:\n#{actual_string}\n"
      end

      def negative_failure_message
        expected_string = display_commands([@expected])
        actual_string = display_commands(@actual)
        "This command should not have been run, but was:\n#{expected_string}\n" <<
          "These were the commands run:\n#{actual_string}\n"
      end

      private

      def display_commands(commands)
        commands.map do |command|
          command.map{|arg| arg.inspect}.join(' ')
        end.join("\n").gsub(/^/, '  ')
      end
    end
  end
end
