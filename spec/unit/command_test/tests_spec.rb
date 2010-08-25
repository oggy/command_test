require 'spec_helper'

describe CommandTest::Tests::RunsCommand do
  describe "when expected matches actual" do
    before do
      @test = CommandTest::Tests::RunsCommand.new(['sh', '-c', 'true']) do
        system 'sh', '-c', 'true'
        system 'sh', '-c', 'false'
      end
    end

    describe "#matches?" do
      it "should return true" do
        @test.matches?.should be_true
      end
    end

    describe "#negative_failure_message" do
      before do
        @test.matches?.should be_true
      end

      it "should return something useful" do
        @test.negative_failure_message.should == <<-EOS.gsub(/^ *\|/, '')
          |This command should not have been run, but was:
          |  "sh" "-c" "true"
          |These were the commands run:
          |  "sh" "-c" "true"
          |  "sh" "-c" "false"
        EOS
      end
    end
  end

  describe "when expected does not match actual" do
    before do
      @test = CommandTest::Tests::RunsCommand.new(['sh', '-c', '']) do
        system 'sh', '-c', 'true'
        system 'sh', '-c', 'false'
      end
    end

    describe "#matches?" do
      it "should return false" do
        @test.matches?.should be_false
      end
    end

    describe "#positive_failure_message" do
      before do
        @test.matches?.should be_false
      end

      it "should return something useful" do
        @test.positive_failure_message.should == <<-EOS.gsub(/^ *\|/, '')
          |This command should have been run, but was not:
          |  "sh" "-c" ""
          |These were the commands run:
          |  "sh" "-c" "true"
          |  "sh" "-c" "false"
        EOS
      end
    end
  end
end
