require 'spec_helper'

describe Rfid::Models::Action do
  before(:each) do
    @device = Rfid::Models::Device.create({ :latitude => 45.56757, :longitude => 43.34234 })
    @action = @device.actions.build({ :title => '1', :klass_name => '1' })
  end
  
  it "should create a new instance given valid attributes" do
    @action.save!
  end
  
  context "validations" do
    it "should not be valid with invalid title" do
      @action.title = nil
      @action.should_not be_valid
    end
    
    it "should not be valid with invalid klass_name" do
      @action.klass_name = nil
      @action.should_not be_valid
    end
  end
end
