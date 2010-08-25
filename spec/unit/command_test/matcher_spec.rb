require 'spec_helper'

describe CommandTest::Matcher do
  before do
    @matcher = CommandTest::Matcher.new
  end

  describe "#match?" do
    describe "when only Strings are in expected" do
      it "should be true if expected is equal to actual" do
        @matcher.match?(['a', 'b'], ['a', 'b']).should be_true
      end

      it "should be false if any element of expected is not the same as actual" do
        @matcher.match?(['a', 'b'], ['a', 'x']).should be_false
      end
    end

    describe "when a Regexp is present" do
      it "should match the corresponding element in actual" do
        @matcher.match?(['a', /\A.\z/], ['a', 'b']).should be_true
      end

      it "should return false if the Regexp does not match" do
        @matcher.match?(['a', /\A..\z/], ['a', 'x']).should be_false
      end
    end

    describe "when an Integer is present" do
      it "should match n elements at that position in actual" do
        @matcher.match?(['a', 2, 'z'], ['a', 'b', 'c', 'z']).should be_true
      end

      it "should support matching 0 elements" do
        @matcher.match?(['a', 0, 'z'], ['a', 'z']).should be_true
      end

      it "should return false if there are not enough elements in actual" do
        @matcher.match?(['a', 2, 'z'], ['a', 'z']).should be_false
      end

      it "should return false if there are too many elements in actual" do
        @matcher.match?(['a', 2, 'z'], ['a', 'b', 'c', 'd', 'z']).should be_false
      end

      it "should raise ArgumentError if the integer is negative" do
        lambda{@matcher.match?(['a', -1, 'b'], ['a', 'b'])}.should raise_error(ArgumentError, /negative/)
      end
    end

    describe "when a Range, a..b, is present" do
      it "should match a elements in the range at that position in actual" do
        @matcher.match?(['a', 2..4, 'z'], ['a', 'b', 'c', 'z']).should be_true
      end

      it "should match b elements in the range at that position in actual" do
        @matcher.match?(['a', 2..4, 'z'], ['a', 'b', 'c', 'd', 'e', 'z']).should be_true
      end

      it "should i elements, for in in a..b" do
        @matcher.match?(['a', 2..4, 'z'], ['a', 'b', 'c', 'd', 'z']).should be_true
      end

      it "should return false if there are not enough elements in actual" do
        @matcher.match?(['a', 2...4, 'z'], ['a', 'b', 'z']).should be_false
      end

      it "should return false if there are too many elements in actual" do
        @matcher.match?(['a', 2...4, 'z'], ['a', 'b', 'c', 'd', 'e', 'f', 'z']).should be_false
      end

      it "should honor open-endedness of the range" do
        @matcher.match?(['a', 2...4, 'z'], ['a', 'b', 'c', 'd', 'e', 'z']).should be_false
      end

      it "should raise ArgumentError if a is negative" do
        lambda{@matcher.match?(['a', -2..4, 'b'], ['a', 'b'])}.should raise_error(ArgumentError, /negative/)
      end

      it "should raise ArgumentError if b is negative" do
        lambda{@matcher.match?(['a', -4..-2, 'b'], ['a', 'b'])}.should raise_error(ArgumentError, /negative/)
      end

      it "should raise ArgumentError if the range is descending" do
        lambda{@matcher.match?(['a', 4..2, 'b'], ['a', 'b'])}.should raise_error(ArgumentError, /descending/)
      end

      it "should return false if the range is empty" do
        @matcher.match?(['a', 2...2, 'z'], ['a', 'z']).should be_false
      end

      it "should backtrack to find a match" do
        @matcher.match?(['a', 1..3, 'm', 1..3, 'z'], ['a', 'b', 'c', 'd', 'm', 'n', 'o', 'p', 'z']).should be_true
      end
    end

    describe "when :* is present" do
      it "should match zero elements at that position in actual" do
        @matcher.match?(['a', :*, 'z'], ['a', 'z']).should be_true
      end

      it "should match one element at that position in actual" do
        @matcher.match?(['a', :*, 'z'], ['a', 'b', 'z']).should be_true
      end

      it "should match two elements at that position in actual" do
        @matcher.match?(['a', :*, 'z'], ['a', 'b', 'c', 'z']).should be_true
      end

      it "should backtrack to find a match" do
        @matcher.match?(['a', :*, 'm', :*, 'z'], ['a', 'b', 'c', 'd', 'm', 'n', 'o', 'p', 'z']).should be_true
      end
    end

    describe "when :+ is present" do
      it "should not match zero elements at that position in actual" do
        @matcher.match?(['a', :+, 'z'], ['a', 'z']).should be_false
      end

      it "should match one element at that position in actual" do
        @matcher.match?(['a', :+, 'z'], ['a', 'b', 'z']).should be_true
      end

      it "should match two elements at that position in actual" do
        @matcher.match?(['a', :+, 'z'], ['a', 'b', 'c', 'z']).should be_true
      end

      it "should backtrack to find a match" do
        @matcher.match?(['a', :+, 'm', :+, 'z'], ['a', 'b', 'c', 'd', 'e', 'm', 'n', 'o', 'p', 'q', 'z']).should be_true
      end
    end

    describe "when junk is present" do
      it "should raise an argument error" do
        lambda{@matcher.match?(['a', Object.new, 'b'], ['a', 'b'])}.should raise_error(ArgumentError, /invalid/)
      end
    end
  end
end
