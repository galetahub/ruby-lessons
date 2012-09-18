require 'spec_helper'

describe Rfid::Models::Device do
  before(:each) do
    @device = Rfid::Models::Device.new({ :title => "Super", :latitude => 45.56757, :longitude => 43.34234 })
  end
  
  it "should create a new instance given valid attributes" do
    @device.save!
  end
  
  it "should create device with given action_klass_name" do
    @device.action_klass_name = 'CardRegister'
    @device.save
    
    @device.actions.first.klass_name.should == 'CardRegister'
  end
  
  context "validations" do
    it "should not be valid with invalid latitude" do
      @device.latitude = 'wrong'
      @device.should_not be_valid
    end
    
    it "should not be valid with invalid longitude" do
      @device.longitude = 'wrong'
      @device.should_not be_valid
    end
    
    it "should not be valid with empty title" do
      @device.title = nil
      @device.should_not be_valid
    end
  end
  
  context "after create" do
    before(:each) do
      @device.save
    end
    
    it "should generate unique secret_token" do
      @device.secret_token.should_not be_nil
      Rfid::Models::Device.where(:secret_token => @device.secret_token).count.should == 1
    end
    
    it "should create default action" do
      @device.current_action.should_not be_nil
      @device.actions.count.should == 1
    end
  end
  
  context "actions" do
    before(:each) do
      @action1 = Rfid::Models::Action.new(:title => '1', :klass_name => '1')
      @action2 = Rfid::Models::Action.new(:title => '2', :klass_name => '2')
      
      @action1.created_at = 1.day.ago
      @action2.created_at = 1.day.from_now
      
      @device.save
      @device.actions.concat([@action1, @action2])
    end
    
    it "should append actions to device" do
      @device.actions.count.should == 3
    end
    
    it "should return last action" do
      @device.current_action.should == @action2
    end
  end
end
