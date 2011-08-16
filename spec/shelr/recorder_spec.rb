require 'spec_helper'

describe Shelr::Recorder do

  before(:each) do
    STDIN.stubs(:gets).returns('my shellcast')
  end

  describe "#record!" do

    before(:each) do
      subject.stubs(:system).with(anything).returns(true)
    end

    it "should set tty to 80x24" do
      subject.expects("system").with(regexp_matches(/stty columns 80 rows 24/))
      subject.record!
    end

    it "should restore tty to user defined values" do
      subject.expects(:restore_terminal)
      subject.record!
    end

    it "should start script session" do
      subject.expects("system").with(regexp_matches Regexp.compile("script -c 'bash'"))
      subject.record!
    end
  end

  describe "#restore_terminal" do
    it "should call tty with saved dimensions" do
      subject.expects(:system).with(
        all_of(regexp_matches(/stty/),
               regexp_matches(/columns/),
               regexp_matches(/rows/))
      )
      subject.send :restore_terminal
    end
  end
end
