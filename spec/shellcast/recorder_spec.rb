require 'spec_helper'

describe ShellCast::Recorder do
  describe "#record!" do
    it "should start script session" do
      subject.should_receive("system").with(anything)
      subject.record!
    end
  end
end
