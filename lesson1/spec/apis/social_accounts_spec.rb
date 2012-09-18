require 'spec_helper'

describe Rfid::Apis::SocialAccounts do
  def app
    Rfid::API
  end
  
  before(:all) do
    @attrs = { :uid => '2592709',
      :provider => 'vkontakte',
      :namespace => 'test',
      :auth_hash => {"user_info"=>{"name"=>"Павел Галета", "location"=>", ", "urls"=>{"Vkontakte"=>"http://vkontakte.ru/id2592709"}, "nickname"=>"", "birth_date"=>"10.3.1987", "last_name"=>"Галета", "image"=>"http://cs10901.vkontakte.ru/u2592709/e_f8b6e3b9.jpg", "first_name"=>"Павел"}, "uid"=>2592709, "credentials"=>{"token"=>"7a1cfdd37a3b72167a3b7216ac7a1347bde7a3b7a3a7216c95a735a210be6d4"}, "extra"=>{"user_hash"=>{"timezone"=>2, "gender"=>"2", "photo_big"=>"http://cs10901.vkontakte.ru/u2592709/a_d8f124ce.jpg"}}, "provider"=>"vkontakte"} }
  end
  
  after(:each) do
    Rfid::Models::SocialAccount.delete_all
  end
  
  context "with_authentication" do
    before(:each) do
      authorize 'demo', 'demo'
    end
    
    it 'should create new social_account' do
      lambda {
        post "/api/v1/social_accounts.xml", :social_account => @attrs
      }.should change { Rfid::Models::SocialAccount.count }.by(1)
    end
    
    it 'should create new social_account with card' do
      @card = Rfid::Models::Card.create(:uid => 'test', :role_type => 1)
      
      lambda {
        post "/api/v1/social_accounts.xml", :social_account => @attrs.merge(:card_id => @card.id)
      }.should change { Rfid::Models::SocialAccount.count }.by(1)
      
      @card.reload
      @card.should_not be_available
    end
    
    it 'should associate exist social_account with card' do
      @account = Rfid::Models::SocialAccount.create(@attrs)
      @card = Rfid::Models::Card.create(:uid => 'test2', :role_type => 1)
      
      lambda {
        post "/api/v1/social_accounts.xml", :social_account => @attrs.merge(:card_id => @card.id)
      }.should_not change { Rfid::Models::SocialAccount.count }
      
      @account.reload
      @card.reload
      @card.social_account.should == @account
      @account.cards.should include(@card)
      
      last_response.body.should include("<card>")
    end
    
    it "should not create social_account with invalid params" do
      lambda {
        post "/api/v1/social_accounts.xml", :social_account => @attrs.merge(:provider => nil)
      }.should_not change { Rfid::Models::SocialAccount.count }
      
      last_response.status.should == 422
      last_response.body.should include("<errors>")
    end
    
    it "should return 404 page" do
      get "/api/v1/social_accounts/4e297c93c5466140db000003.xml"
      
      last_response.body.should include("Document not found")
      last_response.status.should == 404
    end
    
    context "exists social_account" do
      before(:each) do
        @account = Rfid::Models::SocialAccount.create(@attrs)
      end
      
      it "should render all social_accounts" do
        get "/api/v1/social_accounts.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@account._id.to_s)
      end
      
      it "should render one social_account" do
        get "/api/v1/social_accounts/#{@account.id}.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@account.id.to_s)
      end
      
      it "should render one social_account with cards" do
        item = @account.cards.create!({ :uid => Rfid.friendly_token, :role_type => 1 })
        get "/api/v1/social_accounts/#{@account.id}/cards.xml"
        
        last_response.status.should == 200
        last_response.body.should include(item.id.to_s)
      end
      
      it "should update social_account" do
        put "/api/v1/social_accounts/#{@account.id}.xml", :social_account => { :namespace => 'super-test' }
        
        last_response.status.should == 200
        last_response.body.should include(@account.id.to_s)
        last_response.body.should include("super-test")
      end
      
      it "should destroy social_account" do
        lambda {
          delete "/api/v1/social_accounts/#{@account.id}.xml"
        }.should change { Rfid::Models::SocialAccount.count }.by(-1)
      end
    end
  end
  
  context "without authentication" do
    it "should not render all social_accounts" do
      get "/api/v1/social_accounts.xml"
      last_response.status.should == 401
    end
    
    it "should not create social_account" do
      post "/api/v1/social_accounts.xml", :social_account => @attrs
      last_response.status.should == 401
    end
  end
  
  context "with bad authentication" do
    before(:each) do
      authorize 'wrong', 'wrong'
    end
    
    it "should not render all social_accounts" do
      get "/api/v1/social_accounts.xml"
      last_response.status.should == 401
    end
    
    it "should not create social_account" do
      post "/api/v1/social_accounts.xml", :social_account => @attrs
      last_response.status.should == 401
    end
  end
end
