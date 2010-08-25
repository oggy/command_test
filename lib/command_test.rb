require 'shellwords'
require 'command_test/core_extensions'
require 'command_test/parser'
require 'command_test/matcher'
require 'command_test/adapters'
require 'command_test/tests'

module CommandTest
  class << self
    #
    # Return the list of commands run during the given block.
    #
    # Each command is an Array of "words" (command and arguments).
    #
    def record
      commands = []
      recorders << lambda{|c| commands << c}
      begin
        yield
      ensure
        recorders.pop
      end
      commands
    end

    #
    # Return true if the given +actual+ command matches the +expected+
    # spec.
    #
    # The elements of +expected+ may be one of these:
    #
    #  * A String in +expected+ matches the corresponding element in
    #    +actual+.
    #  * A Regexp must match the corresponding element in +actual+.
    #  * An Integer, n, matches the next n elements of +actual+.
    #  * A Range, a...b, can match the next i elements of +actual+,
    #    for a <= i < b.
    #  * :+ can match 1 or more elements in +actual+.
    #  * :* can match any number of elements (including zero) in
    #    +actual+.
    #
    def match?(expected, actual)
      matcher.match?(expected, actual)
    end

    def record_command(command, *args) # :nodoc:
      words = Shellwords.shellwords(command).concat(args)
      recorders.each{|r| r.call(words)}
    end

    def record_interpreted_command(command) # :nodoc:
      words = parser.parse(command)
      recorders.each{|r| r.call(words)}
    end

    private

    def recorders
      Thread.current[:command_recorders] ||= []
    end

    def parser
      @parser ||= Parser.new
    end

    def matcher
      @matcher ||= Matcher.new
    end
  end
end
