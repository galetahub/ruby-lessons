require 'spec_helper'

describe Rfid::Strategies::CardRegister do
  include DeviceHelper
  
  before(:each) do
    init_event_with_cards
    @strategy = Rfid::Strategies::CardRegister.new(@devise)
  end
  
  it "should call register_card strategy" do
    @event.income_params[:cards] = 'uniquekey'
    
    hash = @strategy.call(@event)
    hash[:event].should == 'card_register'
    hash[:data].should_not be_empty
    hash[:data].size.should == 1
  end
  
  it "should register multiplay cards" do
    @event.income_params[:cards] = ['blablabla', 'secondkey']
    
    lambda {
      @strategy.call(@event)
    }.should change { Rfid::Models::Card.count }.by(2)
  end
  
  it "should return error on empty cards" do
    @event.income_params[:cards] = ''
        
    hash = @strategy.call(@event)
    hash[:event].should == 'error'
    hash[:data][:code].should == 41
  end
end