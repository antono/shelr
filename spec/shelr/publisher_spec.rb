require 'spec_helper'

describe Shelr::Publisher do
  before :each do
    File.stub(:open)
    Net::HTTP.stub(:post_form)
  end

  describe "#publish(id)" do
    it "should prepare record as json" do
      STDIN.stub(:gets).and_return('something')
      subject.stub(:handle_response)
      subject.stub(:prepare).and_return(fixture('record1.json'))
      subject.should_receive(:prepare).with('hello')

      subject.publish('hello')
    end
  end

  describe "#dump_filename" do
    it "should return `pwd` + /shelr-record.json" do
      subject.send(:dump_filename).should == File.join(Dir.getwd, 'shelr-record.json')
    end
  end

  describe "#dump(id)" do
    before :each do
      @file = mock('dump file')
      File.stub(:open).and_yield @file
    end

    it "should save prepared dump to #dump_filename" do
      File.should_receive(:open).with(subject.send(:dump_filename), 'w+')
      subject.should_receive(:prepare).with('hello').and_return('dump')
      @file.should_receive(:puts).with('dump')
      subject.dump('hello')
    end
  end

end
