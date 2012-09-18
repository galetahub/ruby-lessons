require 'spec_helper'

describe Rfid::Apis::Actions do
  include DeviceHelper
  
  def app
    Rfid::API
  end
  
  before(:all) do
    @device = create_device
    @attrs = { :title => 'New Action', :klass_name => 'DefaultRunner' }
  end
  
  context "with_authentication" do
    before(:each) do
      authorize 'demo', 'demo'
    end
    
    it 'should create new action' do
      lambda {
        post "/api/v1/devices/#{@device.id}/actions.xml", :action => @attrs
      }.should change { @device.actions.count }.by(1)
    end
    
    it "should not create action with invalid params" do
      lambda {
        post "/api/v1/devices/#{@device.id}/actions.xml", :action => @attrs.merge(:title => nil)
      }.should_not change { Rfid::Models::Action.count }
      
      last_response.status.should == 422
      last_response.body.should include("<errors>")
    end
    
    context "exists action" do
      before(:each) do
        @action = @device.actions.create(@attrs)
      end
      
      it "should render all actions" do
        get "/api/v1/devices/#{@device.id}/actions.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@action.id.to_s)
      end
      
      it "should render one action" do
        get "/api/v1/devices/#{@device.id}/actions/#{@action.id}.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@action.id.to_s)
      end
      
      it "should update action" do
        put "/api/v1/devices/#{@device.id}/actions/#{@action.id}.xml", :action => { :title => "Updated title" }
        
        last_response.status.should == 200
        last_response.body.should include(@action.id.to_s)
        last_response.body.should include("Updated title")
      end
      
      it "should destroy action" do
        lambda {
          delete "/api/v1/devices/#{@device.id}/actions/#{@action.id}.xml"
        }.should change { @device.actions.count }.by(-1)
      end
    end
  end
  
  context "without authentication" do
    it "should not render all actions" do
      get "/api/v1/devices/#{@device.id}/actions.xml"
      last_response.status.should == 401
    end
    
    it "should not create action" do
      post "/api/v1/devices/#{@device.id}/actions.xml", :action => @attrs
      last_response.status.should == 401
    end
  end
  
  context "with bad authentication" do
    before(:each) do
      authorize 'wrong', 'wrong'
    end
    
    it "should not render all actions" do
      get "/api/v1/devices/#{@device.id}/actions.xml"
      last_response.status.should == 401
    end
    
    it "should not create action" do
      post "/api/v1/devices/#{@device.id}/actions.xml", :action => @attrs
      last_response.status.should == 401
    end
  end
end
