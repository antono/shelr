require 'spec_helper'

describe Shelr::Publisher do
  before do
    STDOUT.stub(:puts)
    STDOUT.stub(:print)
    File.stub(:open)
    Net::HTTP.stub(:post_form)
  end

  describe "#publish(id)" do
    before do
      STDIN.stub(:gets).and_return('something')
      subject.stub(:handle_response)
      subject.stub(:prepare).and_return(Fixture::load('record1.json'))
    end

    it "prepares record as json" do
      subject.should_receive(:prepare).with('hello')
      subject.publish('hello')
    end

    it "it checks that file is not locked" do
      subject.stub(:ensure_unlocked)
      subject.should_receive(:ensure_unlocked).with('hello')
      subject.publish('hello')
    end
  end

  describe "#dump_filename" do
    it "returns `pwd` + /shelr-record.json" do
      subject.send(:dump_filename).should == File.join(Dir.getwd, 'shelr-record.json')
    end
  end

  describe "#dump(id)" do
    let(:file) { mock('dump file') }

    before do
      File.stub(:open).and_yield file
    end

    it "saves prepared dump to #dump_filename" do
      File.should_receive(:open).with(subject.send(:dump_filename), 'w+')
      subject.should_receive(:prepare).with('hello').and_return('dump')
      file.should_receive(:puts).with('dump')
      subject.dump('hello')
    end
  end

end
