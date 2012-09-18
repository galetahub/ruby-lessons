require 'spec_helper'

describe Rfid::Utils do
  it "should be a module" do
    Rfid::Utils.should be_a(Module)
  end
  
  context "Inflector" do
    it "should pluralize klass" do
      Rfid::Utils.pluralize(Rfid::Models::Device).should == "devices"
      Rfid::Utils.pluralize(Rfid::Models::SocialAccount).should == "social_accounts"
    end
    
    it "should singularize klass" do
      Rfid::Utils.singularize(Rfid::Models::Device).should == "device"
      Rfid::Utils.singularize(Rfid::Models::SocialAccount).should == "social_account"
    end
    
    it "should extract (underscore only last) klass" do
      Rfid::Utils.extract_klass(Rfid::Models::Device).should == "device"
      Rfid::Utils.extract_klass(Rfid::Models::SocialAccount).should == "social_account"
    end
  end
end
