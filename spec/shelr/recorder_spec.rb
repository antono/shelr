require 'spec_helper'

describe Shelr::Recorder do

  before(:each) do
    STDIN.stub(:gets).and_return('my shellcast')
    Shelr.backend = 'script'
  end

  describe "#record!" do
    before(:each) do
      subject.stub(:system).with(anything).and_return(true)
    end

    it "should start script session" do
      subject.should_receive("system").with(Regexp.compile("script"))
      subject.record!
    end
  end
end
