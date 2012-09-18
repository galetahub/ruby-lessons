require 'spec_helper'

describe Rfid do
  it "should be a module" do
    Rfid.should be_a(Module)
  end
  
  it "should set root path" do
    Rfid.root_path.should_not be_nil
    File.exists?(Rfid.root_path).should be_true
  end
  
  context "config" do
    it "should load and parse config file" do
      Rfid.config.should_not be_nil
      Rfid.config.username.should == "aimbulance"
    end
  end
end
