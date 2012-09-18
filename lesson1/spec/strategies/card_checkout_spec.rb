require 'spec_helper'

describe Rfid::Strategies::CardCheckout do
  include DeviceHelper
  
  before(:each) do
    init_event_with_cards
    @account = create_social_account
    @card1.social_account = @account
    @card1.save
    @strategy = Rfid::Strategies::CardCheckout.new(@devise)
  end
  
  it "should call card_checkout strategy" do
    hash = @strategy.call(@event)
    hash[:event].should == 'checkout/callback'
    hash[:data][:card].should == @card1
    hash[:data][:account].should == @account
  end  
  
  it "should return error on empty card" do
    @event.income_cards = []
        
    hash = @strategy.call(@event)
    hash[:event].should == 'error'
    hash[:data][:code].should == 41
  end
  
  it "should call card_checkout strategy without social_account" do
    @card1.social_account.destroy
        
    hash = @strategy.call(@event)
    hash[:event].should == 'checkout/callback'
    hash[:data][:card].should == @card1
    hash[:data][:account].should be_nil
  end
end
