require 'spec_helper'

describe Rfid::Apis::Devices do
  def app
    Rfid::API
  end
  
  before(:all) do
    @attrs = { :latitude => 45.56757, :longitude => 43.34234 }
  end
  
  context "with_authentication" do
    before(:each) do
      authorize 'demo', 'demo'
    end
    
    it 'should create new device' do
      lambda {
        post "/api/v1/devices.xml", :device => @attrs
      }.should change { Rfid::Models::Device.count }.by(1)
    end
    
    it "should not create device with invalid params" do
      lambda {
        post "/api/v1/devices.xml", :device => @attrs.merge(:latitude => 'wrong')
      }.should_not change { Rfid::Models::Device.count }
      
      last_response.status.should == 422
      last_response.body.should include("<errors>")
    end
    
    it "should not create device with invalid params via json" do
      post "/api/v1/devices.json", :device => @attrs.merge(:latitude => 'wrong')
      
      last_response.status.should == 422
      last_response.body.should include("errors")
    end
    
    it "should return 404 page" do
      get "/api/v1/devices/4e297c93c5466140db000003.xml"
      
      last_response.body.should include("Document not found")
      last_response.status.should == 404
    end
    
    context "exists device" do
      before(:each) do
        @device = Rfid::Models::Device.create(@attrs)
      end
      
      it "should render all devices" do
        get "/api/v1/devices.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@device.id.to_s)
      end
      
      it "should render one device with actions" do
        get "/api/v1/devices/#{@device.id}.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@device.id.to_s)
        last_response.body.should include(@device.actions[0].id.to_s)
      end
      
      it "should update device" do
        put "/api/v1/devices/#{@device.id}.xml", :device => { :latitude => 50.005 }
        
        last_response.status.should == 200
        last_response.body.should include(@device.id.to_s)
        last_response.body.should include("50.005")
      end
      
      it "should destroy device" do
        lambda {
          delete "/api/v1/devices/#{@device.id}.xml"
        }.should change { Rfid::Models::Device.count }.by(-1)
      end
    end
  end
  
  context "without authentication" do
    it "should not render all devices" do
      get "/api/v1/devices.xml"
      last_response.status.should == 401
    end
    
    it "should not create devices" do
      post "/api/v1/devices.xml", :device => @attrs
      last_response.status.should == 401
    end
  end
  
  context "with bad authentication" do
    before(:each) do
      authorize 'wrong', 'wrong'
    end
    
    it "should not render all devices" do
      get "/api/v1/devices.xml"
      last_response.status.should == 401
    end
    
    it "should not create devices" do
      post "/api/v1/devices.xml", :device => @attrs
      last_response.status.should == 401
    end
  end
end
