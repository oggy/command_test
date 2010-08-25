require 'spec_helper'

describe CommandTest do
  describe ".record" do
    def self.it_should_record_interpreted(method, options={}, &block)
      describe "when #{method} is called during the block" do
        define_method(:run){|*args| block.call(*args)}

        it "should record the command run" do
          commands = CommandTest.record do
            run "sh -c true"
          end
          commands.should == [['sh', '-c', 'true']]
        end

        it "should parse the command like a shell" do
          commands = CommandTest.record do
            run "sh -c echo 'a b' > /dev/null"
          end
          commands.should == [['sh', '-c', 'echo', 'a b']]
        end
      end
    end

    def self.it_should_record(method, options={}, &block)
      describe "when #{method} is called during the block" do
        define_method(:run){|*args| block.call(*args)}

        it "should record the command run" do
          commands = CommandTest.record do
            run 'sh', '-c', 'true'
          end
          commands.should == [['sh', '-c', 'true']]
        end

        it "should expand the first and only the first argument" do
          commands = CommandTest.record do
            run 'sh -c echo', 'a b'
          end
          commands.should == [['sh', '-c', 'echo', 'a b']]
        end
      end
    end

    it_should_record("system") do |*args|
      system(*args)
    end

    it_should_record("Kernel.system") do |*args|
      Kernel.system(*args)
    end

    it_should_record_interpreted("`") do |command|
      `#{command}`
    end

    it_should_record_interpreted("Kernel.`") do |command|
      Kernel.send('`', command)
    end

    it_should_record_interpreted("open") do |command|
      open("|#{command}"){}
    end

    it_should_record_interpreted("Kernel.open") do |command|
      Kernel.open("|#{command}"){}
    end

    it_should_record_interpreted("IO.popen") do |command|
      IO.popen(command){}
    end

    it_should_record("popen3") do |*args|
      Class.new{include Open3}.new.instance_eval do
        popen3(*args){}
      end
    end

    it_should_record("Open3.popen3") do |*args|
      Open3.popen3(*args){}
    end

    describe "when multiple commands are run during the block" do
      it "should return all the commands run" do
        commands = CommandTest.record do
          system 'sh', '-c', 'true'
          system 'sh', '-c', 'false'
        end
        commands.should == [['sh', '-c', 'true'], ['sh', '-c', 'false']]
      end
    end
  end
end
