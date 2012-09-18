require 'spec_helper'

describe Rfid::Models::Relay do
  before(:each) do
    @device = Rfid::Models::Device.create({ :latitude => 45.56757, :longitude => 43.34234 })
    @relay = @device.relays.new(:title => 'Test title', :info => 'Test info')
  end
  
  it "should create a new instance given valid attributes" do
    @relay.save!
  end
  
  context "validations" do
    it "should not be valid with invalid title" do
      @relay.title = nil
      @relay.should_not be_valid
    end
    
    it "should not be valid with invalid info" do
      @relay.info = nil
      @relay.should_not be_valid
    end
  end
end
