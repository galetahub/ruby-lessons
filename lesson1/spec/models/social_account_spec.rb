require 'spec_helper'

describe Rfid::Models::SocialAccount do
  before(:each) do
    @account = Rfid::Models::SocialAccount.new(
      :uid => '2592709',
      :provider => 'vkontakte',
      :namespace => 'test',
      :auth_hash => {"info"=>{"name"=>"Павел Галета", "location"=>", ", "urls"=>{"Vkontakte"=>"http://vkontakte.ru/id2592709"}, "nickname"=>"", "birth_date"=>"10.3.1987", "last_name"=>"Галета", "image"=>"http://cs10901.vkontakte.ru/u2592709/e_f8b6e3b9.jpg", "first_name"=>"Павел"}, "uid"=>2592709, "credentials"=>{"token"=>"7a1cfdd37a3b72167a3b7216ac7a1347bde7a3b7a3a7216c95a735a210be6d4"}, "extra"=>{"raw_info"=>{"timezone"=>2, "gender"=>"2", "photo_big"=>"http://cs10901.vkontakte.ru/u2592709/a_d8f124ce.jpg"}}, "provider"=>"vkontakte"}
    )
  end
  
  after(:each) do
    Rfid::Models::SocialAccount.delete_all
  end
  
  it "should create a new instance given valid attributes" do
    @account.save!
  end
  
  context "validations" do
    it "should not be valid with invalid uid" do
      @account.uid = nil
      @account.should_not be_valid
    end
    
    it "should not be valid with invalid provider" do
      @account.provider = nil
      @account.should_not be_valid
    end
    
    it "should not be valid with not unique uid and provider" do
      Rfid::Models::SocialAccount.create(:uid => '2592709', :provider => 'vkontakte', :auth_hash => {:test => 1})
      @account.should_not be_valid
    end
  end
  
  context "cards" do
    before(:each) do
      @card = Rfid::Models::Card.create(:uid => 'test', :role_type => 1)
    end
    
    it "should create account with card" do
      @account.card_id = @card.id
      
      lambda { 
        @account.save
      }.should change { @account.cards.count }.by(1)
    end
    
    it "should not create card for exists account" do
      @card.social_account = Rfid::Models::SocialAccount.create(:uid => '2592709', :provider => 'vkontakte', :auth_hash => {:test => 1})
      @card.save
      
      @card.available?.should be_false
      
      @account.card_id = @card.id
      
      lambda { 
        @account.save
      }.should_not change { @account.cards.count }
    end
    
    it "should not raise error" do
      lambda { 
        @account.card_id = nil
        @account.card_id = 'wrong'
      }.should_not raise_error
    end
  end
  
  context "after_create" do
    before(:each) do
      @account.save!
    end
    
    it "should parse account info" do
      @account.name.should == 'Павел Галета'
      @account.email.should == nil
      @account.access_token.should == '7a1cfdd37a3b72167a3b7216ac7a1347bde7a3b7a3a7216c95a735a210be6d4'
      @account.namespace.should == 'test'
    end
  end
end
