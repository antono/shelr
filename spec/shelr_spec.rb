require 'spec_helper'

describe Shelr do
  it "should have ::APP_NAME defined" do
    Shelr::APP_NAME.should == 'shelr'
  end

  it "should provide XDG and APP_NAME based ::DATA_DIR" do
    Shelr::DATA_DIR.should == File.join(XDG['DATA_HOME'], Shelr::APP_NAME)
  end

  it "should provide XDG config path" do
    Shelr::CONFIG_DIR.should == File.join(XDG['CONFIG_HOME'], Shelr::APP_NAME)
  end
end
