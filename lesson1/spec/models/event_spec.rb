require 'spec_helper'

describe Rfid::Models::Event do
  include DeviceHelper
  
  before(:each) do
    @device = Rfid::Models::Device.create({ :latitude => 45.56757, :longitude => 43.34234 })
    @action = @device.actions.first
    @card1 = create_card
    @card2 = create_card
    
    @attrs = events_attrs(@device, { :cards => [@card2.id, @card1.id] })
    @event = @device.events.build(:params => @attrs)
  end
  
  it "should create a new instance given valid attributes" do
    @event.save!
  end
  
  context "create from params" do
    before(:each) do
      @event = @device.events.build
    end
    
    it "should be empty event" do
      @event.participants.size.should be_zero
    end
    
    it "should not be valid with invalid hash" do
      @event.params = @attrs.merge(:hash => 'wrong')
      @event.should_not be_valid
    end
    
    it "should not be valid with empty participants" do
      @event.params = @attrs.merge(:cards => [])
      @event.should_not be_valid
    end
    
    it "should ignore invalid card ids" do
      @event.params = @attrs.merge(:cards => [@card2.id.to_s, 'wrong', nil, 123])
      @event.participants.size.should == 1
      @event.participants.map(&:card).should include(@card2)
    end
    
    it "should create event by card's uid" do
      @event.params = @attrs.merge(:cards => [@card2.uid, @card1.uid])
      @event.participants.size.should == 2
      @event.participants.map(&:card).should include(@card2)
      @event.participants.map(&:card).should include(@card1)
    end
    
    it "should ignore not exists cards ids" do
      @event.params = @attrs.merge(:cards => ['4e200ff5de2f15334a000001', @card1.id.to_s, '4e201061de2f153358000001'])
      @event.participants.size.should == 1
      @event.participants.map(&:card).should include(@card1)
    end
    
    it "should create participants" do
      @event.participants.count.should be_zero
      @event.params = @attrs
      
      lambda {
        @event.save
      }.should change { Rfid::Models::Participant.count }.by(2)
    end
  end
  
  context "validations" do
    it "should not be valid with invalid device" do
      @event.device = nil
      @event.should_not be_valid
    end
    
    it "should not be valid with invalid mode" do
      @event.mode = 'wrong'
      @event.should_not be_valid
    end
    
    it "should not be valid with invalid performed_at" do
      @event.performed_at = nil
      @event.should_not be_valid
    end
  end
  
  context "after create" do
    before(:each) do
      @event.save!
    end
    
    it "should save event" do
      @event.should be_persisted
    end
    
    it "should set current device action" do
      @event.action.should == @device.current_action
      @event.action.should == @action
    end
    
    it "should create new participants" do
      @event.participants.count.should == 2
      @event.participants.map(&:card).should include(@card2)
      @event.participants.map(&:card).should include(@card1)
    end
  end
  
  context "serialization" do
    before(:each) do
      @event.save!
    end
    
    it "should return json" do
      @event.to_json.should include "participants"
    end
    
    it "should return xml" do
      @event.to_xml(:include => :participants).should include "participants"
    end
  end
end
