require 'spec_helper'

describe CommandTest::CoreExtensions do
  it "should not affect system" do
    system 'true'
    $?.success?.should be_true
    system 'false'
    $?.success?.should be_false
  end

  it "should not affect Kernel.system" do
    Kernel.system 'true'
    $?.success?.should be_true
    Kernel.system 'false'
    $?.success?.should be_false
  end

  it "should not affect `" do
    `true`
    $?.success?.should be_true
    `false`
    $?.success?.should be_false
  end

  it "should not affect Kernel.`" do
    Kernel.send('`', 'true')
    $?.success?.should be_true
    Kernel.send('`', 'false')
    $?.success?.should be_false
  end

  it "should not affect open with a pipe" do
    open('|true'){}
    $?.success?.should be_true
    open('|false'){}
    $?.success?.should be_false
  end

  it "should not affect open without a pipe" do
    path = write_temporary_file('file', 'content')
    content = nil
    open(path){|f| content = f.read}
    content.should == 'content'
  end

  it "should not affect Kernel.open with a pipe" do
    Kernel.open('|true'){}
    $?.success?.should be_true
    Kernel.open('|false'){}
    $?.success?.should be_false
  end

  it "should not affect Kernel.open without a pipe" do
    path = write_temporary_file('file', 'content')
    content = nil
    Kernel.open(path){|f| content = f.read}
    content.should == 'content'
  end

  it "should not affect IO.popen" do
    IO.popen('true'){}
    $?.success?.should be_true
    IO.popen('false'){}
    $?.success?.should be_false
  end

  it "should not affect popen3" do
    out = nil
    Class.new{include Open3}.new.instance_eval do
      popen3('echo a'){|stdin, stdout, stderr| out = stdout.read}
    end
    out.should == "a\n"
  end

  it "should not affect Open3.popen3" do
    out = nil
    Class.new{include Open3}.new.instance_eval do
      Open3.popen3('echo a'){|stdin, stdout, stderr| out = stdout.read}
    end
    out.should == "a\n"
  end
end
