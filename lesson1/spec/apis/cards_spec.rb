require 'spec_helper'

describe Rfid::Apis::Cards do
  def app
    Rfid::API
  end
  
  before(:all) do
    @attrs = { :uid => 'super_secret_uid', :role_type => 1 }
  end
  
  context "with_authentication" do
    before(:each) do
      authorize 'demo', 'demo'
    end
    
    it 'should create new card' do
      lambda {
        post "/api/v1/cards.xml", :card => @attrs
      }.should change { Rfid::Models::Card.count }.by(1)
    end
    
    it "should not create card with invalid params" do
      lambda {
        post "/api/v1/cards.xml", :card => @attrs.merge(:role_type => 'wrong')
      }.should_not change { Rfid::Models::Card.count }
      
      last_response.status.should == 422
      last_response.body.should include("<errors>")
    end
    
    context "exists card" do
      before(:each) do
        Rfid::Models::Card.destroy_all
        @card = Rfid::Models::Card.create(@attrs)
      end
      
      it "should render all cards" do
        get "/api/v1/cards.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@card.id.to_s)
      end
      
      it "should render one card" do
        get "/api/v1/cards/#{@card.id}.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@card.id.to_s)
      end
      
      it "should update card" do
        put "/api/v1/cards/#{@card.id}.xml", :card => { :uid => "other_super_secret_uid" }
        
        last_response.status.should == 200
        last_response.body.should include(@card.id.to_s)
        last_response.body.should include("other_super_secret_uid")
      end
      
      it "should destroy card" do
        lambda {
          delete "/api/v1/cards/#{@card.id}.xml"
        }.should change { Rfid::Models::Card.count }.by(-1)
      end
    end
  end
  
  context "without authentication" do
    it "should not render all cards" do
      get "/api/v1/cards.xml"
      last_response.status.should == 401
    end
    
    it "should not create cards" do
      post "/api/v1/cards.xml", :card => @attrs
      last_response.status.should == 401
    end
  end
  
  context "with bad authentication" do
    before(:each) do
      authorize 'wrong', 'wrong'
    end
    
    it "should not render all cards" do
      get "/api/v1/cards.xml"
      last_response.status.should == 401
    end
    
    it "should not create cards" do
      post "/api/v1/cards.xml", :card => @attrs
      last_response.status.should == 401
    end
  end
end
