require 'spec_helper'

describe Rfid::Strategies::DefaultAction do
  include DeviceHelper
  
  before(:each) do
    init_event_with_cards
    @strategy = Rfid::Strategies::DefaultAction.new(@devise)
  end
  
  it "should call default_action strategy" do
    @strategy.call(@event).should == {:event => 'default_action', :data => @event.income_params }
  end
end