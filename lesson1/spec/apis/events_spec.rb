require 'spec_helper'

describe Rfid::Apis::Events do
  include DeviceHelper
  
  def app
    Rfid::API
  end

  before(:all) do
    @card1 = create_card
    @card2 = create_card
    @device = create_device
    @device.actions.create(:title => 'Firts action', :klass_name => 'DefaultAction')
    @attrs = events_attrs(@device, { :cards => [@card2.id.to_s, @card1.id.to_s] })
  end
  
  context "with_authentication" do
    before(:each) do
      authorize 'demo', 'demo'
    end
    
    it "should create new event" do
      lambda {
        post "/api/v1/devices/#{@device.id}/events.xml", :event => @attrs
      }.should change { @device.events.count }.by(1)
    end
    
    it "should create new event by short url" do
      lambda {
        post "/api/v1/events/#{@device.id}.xml", @attrs
      }.should change { @device.events.count }.by(1)
    end
    
    it "should not create new event with invalid hash" do
      lambda {
        post "/api/v1/devices/#{@device.id}/events.xml", @attrs.merge(:hash => 'wrong')
      }.should_not change { @device.events.count }
    end
    
    context "exists event" do
      before(:each) do
        @event = @device.events.create(:params => @attrs)
      end
      
      it "should render one event by xml" do
        get "/api/v1/events/#{@event.id}.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@event.id.to_s)
        last_response.body.should include(@card1.id.to_s)
        last_response.body.should include(@card2.id.to_s)
      end
      
      it "should render one event by json" do
        get "/api/v1/events/#{@event.id}.json"
        
        last_response.status.should == 200
        last_response.body.should include(@event.id.to_s)
        last_response.body.should include(@card1.id.to_s)
        last_response.body.should include(@card2.id.to_s)
        last_response.body.should include("data")
      end
      
      it "should destroy event" do
        lambda {
          delete "/api/v1/events/#{@event.id}.xml"
        }.should change { Rfid::Models::Event.count }.by(-1)
      end
    end
  end
  
  context "without authentication" do
    it "should create new event by short url" do
      lambda {
        post "/api/v1/events/#{@device.id}.xml", @attrs
      }.should change { @device.events.count }.by(1)
    end
    
    it "should create new event by short url via json" do
      post "/api/v1/events/#{@device.id}.json", @attrs
      
      last_response.status.should == 201
      last_response.body.should include("cards")
      last_response.body.should include("participants")
      last_response.body.should include(@card1.id.to_s)
      last_response.body.should include(@card2.id.to_s)
      last_response.body.should include("data")
    end
    
    it "should not render all device events" do
      get "/api/v1/devices/#{@device.id}/events.xml"
      last_response.status.should == 401
    end
    
    it "should not create device event" do
      post "/api/v1/devices/#{@device.id}/events.xml", @attrs
      last_response.status.should == 401
    end
    
    context "exists event" do
      before(:each) do
        @event = @device.events.create(:params => @attrs)
      end
      
      it "should not render one event" do
        get "/api/v1/events/#{@event.id}.xml"
        last_response.status.should == 401
      end
      
      it "should destroy event" do
        delete "/api/v1/events/#{@event.id}.xml"
        last_response.status.should == 401
      end
    end
  end
end
