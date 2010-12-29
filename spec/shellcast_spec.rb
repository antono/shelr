require 'spec_helper'

describe ShellCast do
  it "should have ::APP_NAME defined" do
    ShellCast::APP_NAME.should == 'shellcast'
  end

  it "should provide XDG and APP_NAME based ::DATA_DIR" do
    ShellCast::DATA_DIR.should == File.join(XDG::Data.home, ShellCast::APP_NAME)
  end

  it "should provide XDG config path" do
    ShellCast::CONFIG_DIR.should == File.join(XDG::Config.home, ShellCast::APP_NAME)
  end
end
