require 'spec_helper'

describe Rfid::Apis::Devices do
  def app
    Rfid::API
  end
  
  it "should return error response" do
    get "/api/v1/errors/simple.json"
    
    last_response.status.should == 500
    last_response.body.should include "error"
  end
  
  it "should send exception to Airbrake" do
    Airbrake.should_receive(:notify_or_ignore)
    get "/api/v1/errors/simple.json"
  end
end
