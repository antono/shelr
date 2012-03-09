require 'spec_helper'

describe Shelr::Recorder do

  before(:each) do
    STDIN.stubs(:gets).returns('my shellcast')
    Shelr.backend = 'script'
  end

  describe "#record!" do
    before(:each) do
      subject.stubs(:system).with(anything).returns(true)
    end

    it "should start script session" do
      subject.expects("system").with(regexp_matches Regexp.compile("script"))
      subject.record!
    end
  end
end
