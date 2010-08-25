require 'spec_helper'

describe CommandTest::Parser do
  describe "#parse" do
    before do
      @parser = CommandTest::Parser.new
    end

    def parse(*args)
      @parser.parse(*args)
    end

    it "should split the given string into shell words" do
      parse('one two three').should == ['one', 'two', 'three']
    end

    it "should support single quoting" do
      parse("'a b' 'c d'").should == ['a b', 'c d']
    end

    it "should not allow escaping single quotes within single quotes" do
      parse("'a\\'b' '").should == ["a\\b "]
    end

    it "should support double quoting" do
      parse('"a b" "c d"').should == ['a b', 'c d']
    end

    it "should allow escaping double quotes within double quotes" do
      parse('"a\\"b" "c\\"d"').should == ['a"b', 'c"d']
    end

    it "should support backslash escapes" do
      parse('a\\ b c\\ d').should == ['a b', 'c d']
    end

    it "should strip input redirects" do
      parse("command 0< file arg").should == ['command', 'arg']
    end

    it "should support omitting the stream number from an input redirect" do
      parse("command <file arg").should == ['command', 'arg']
    end

    it "should allow space after the input operator" do
      parse("command 0< file arg").should == ['command', 'arg']
    end

    it "should strip output redirects" do
      parse("command 1> file arg").should == ['command', 'arg']
    end

    it "should support omitting the stream number from an output redirect" do
      parse("command 1> file arg").should == ['command', 'arg']
    end

    it "should stream append output redirects" do
      parse("command 1>> file arg").should == ['command', 'arg']
    end

    it "should support omitting the stream number from an append output redirect" do
      parse("command >> file arg").should == ['command', 'arg']
    end

    it "should handle multiple redirects" do
      result = parse('command > out 2>> error one < input two ')
      result.should == ['command', 'one', 'two']
    end

    it "should strip stream merges" do
      parse('command 2>&1 arg').should == ['command', 'arg']
    end

    it "should concatenate quoted regions in the same word" do
      parse(%['a'\\ "b" x]).should == ['a b', 'x']
    end

    it "should not concatenate across input redirects" do
      parse('command arg<input').should == ['command', 'arg']
    end

    it "should not concatenate across output redirects" do
      parse('command arg>output').should == ['command', 'arg']
    end

    it "should not concatenate across append redirects" do
      parse('command arg>>output').should == ['command', 'arg']
    end

    it "should concatenate across quoted redirection characters" do
      parse("command 'arg<input'").should == ['command', 'arg<input']
    end

    it "should consider the stream number part of the preceding word if there's no space before an output redirect" do
      parse("command arg2>output").should == ['command', 'arg2']
    end

    it "should ignore trailing whitespace" do
      parse('command arg ').should == ['command', 'arg']
    end

    it "should ignore trailing whitespace after a redirection" do
      parse('command arg > out').should == ['command', 'arg']
    end

    it "should raise an ArgumentError if there is an unmatched single quote" do
      lambda{parse("a'b")}.should raise_error(ArgumentError, /unmatched/i)
    end

    it "should raise an ArgumentError if there is an unmatched double quote" do
      lambda{parse('a"b')}.should raise_error(ArgumentError, /unmatched/i)
    end

    it "should ignore a trailing backslash" do
      parse('a\\').should == ['a']
    end

    it "should not ignore a trailing backslash-escaped backslash" do
      parse('a\\\\').should == ['a\\']
    end

    it "should raise an ArgumentError if there is a missing input redirection source" do
      lambda{parse('command <')}.should raise_error(ArgumentError, /missing.*source/i)
    end

    it "should raise an ArgumentError if there is a missing output redirection target" do
      lambda{parse('command >')}.should raise_error(ArgumentError, /missing.*target/i)
    end

    it "should raise an ArgumentError if there is a missing append redirection source" do
      lambda{parse('command >>')}.should raise_error(ArgumentError, /missing.*target/i)
    end
  end
end
