require 'spec_helper'

describe Shelr do
  it "should have ::APP_NAME defined" do
    Shelr::APP_NAME.should_not be_nil
  end

  it "should provide XDG and APP_NAME based ::DATA_DIR" do
    Shelr::DATA_DIR.should == File.join(ENV['XDG_DATA_HOME'], Shelr::APP_NAME)
  end

  it "should provide XDG config path" do
    Shelr::CONFIG_DIR.should == File.join(ENV['XDG_CONFIG_HOME'], Shelr::APP_NAME)
  end
end
