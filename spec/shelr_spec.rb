require 'spec_helper'

describe Shelr do
  it "has ::APP_NAME defined" do
    Shelr::APP_NAME.should_not be_nil
  end

  it "provides XDG and APP_NAME based ::DATA_DIR" do
    Shelr::DATA_DIR.should == File.join(ENV['XDG_DATA_HOME'], Shelr::APP_NAME)
  end

  it "provides XDG config path" do
    Shelr::CONFIG_DIR.should == File.join(ENV['XDG_CONFIG_HOME'], Shelr::APP_NAME)
  end

  it "provides terminal info" do
    Shelr.terminal.should be_a(Shelr::Terminal)
  end
end
