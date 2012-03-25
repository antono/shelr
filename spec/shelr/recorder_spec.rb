require 'spec_helper'

describe Shelr::Recorder do

  before do
    STDIN.stub(:gets).and_return('my shellcast')
    Shelr.backend = 'script'
  end

  describe "#record!" do
    before do
      subject.stub(:system).with(anything).and_return(true)
    end

    it "starts script session" do
      subject.should_receive(:system).with(/script/)
      subject.record!
    end
  end
end
