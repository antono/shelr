require 'spec_helper'

describe Shelr::Recorder do

  before do
    STDIN.stub(:gets).and_return('my shellcast')
    Shelr.backend = 'script'
    STDOUT.stub(:puts)
    STDOUT.stub(:print)
  end

  describe "#record!" do
    before do
      subject.stub(:system).with(anything).and_return(true)
      subject.stub(:record_id => "1")
      subject.stub(:with_lock_file).and_yield
    end

    it "starts script session" do
      subject.should_receive(:system).with(/script/)
      subject.record!
    end

    it "creates lock file" do
      subject.should_receive(:with_lock_file)
      subject.record!
    end
  end

  describe "#request_metadata" do
    before do
      STDIN.stub(:gets => 'Hello')
      subject.stub(:record_id => "1")
      File.stub(:open => true)
    end

    it "adds columns and rows to @meta" do
      subject.user_rows = 10
      subject.user_columns = 20
      subject.request_metadata
      subject.meta["rows"].should == 10
      subject.meta["columns"].should == 20
    end

    it "adds record_id to @meta as recorded_at" do
      subject.stub(:record_id => 'ololo')
      subject.request_metadata
      subject.meta["recorded_at"].should == 'ololo'
    end

    it "reads title from stdin" do
      STDIN.stub(:gets => 'C00l title')
      subject.request_metadata
      subject.meta["title"].should == 'C00l title'
    end
  end

  describe "#init_terminal" do
    it "gets user_columns and user_rows from system" do
      Shelr.stub(:terminal).and_return(mock(:size => { :width => 10, :height => 20 }))
      subject.send :init_terminal
      subject.user_rows.should == 20
      subject.user_columns.should == 10
    end
  end
end
