require 'spec_helper'

describe Rfid::Models::Card do
  before(:each) do
    @card = Rfid::Models::Card.new(:uid => 'test', :role_type => 1)
  end
  
  after(:each) do
    Rfid::Models::Card.destroy_all
  end
  
  it "should create a new instance given valid attributes" do
    @card.save!
  end
  
  context "validations" do
    it "should not be valid with invalid uid" do
      @card.uid = nil
      @card.should_not be_valid
    end
    
    it "card not be valid with invalid role_type" do
      @card.role_type = 'wrong'
      @card.should_not be_valid
    end
    
    it "should not be valid with exists uid" do
      Rfid::Models::Card.create(:uid => 'test', :role_type => 1)
      @card.should_not be_valid
    end
  end
  
  context "search keys" do
    before(:each) do
      @card.save
      @card2 = Rfid::Models::Card.create(:uid => 'test2', :role_type => 1)
      @card3 = Rfid::Models::Card.create(:uid => 'test3', :role_type => 1)
    end
    
    it "should find cards by uids" do
      items = Rfid::Models::Card.with_keys(:uids => ['test2', 'test']).all
      items.size.should == 2
      items.should include @card
      items.should include @card2
    end
    
    it "should find card by uid" do
      items = Rfid::Models::Card.with_keys(:uids => ['test3']).all
      items.size.should == 1
      items.should include @card3
    end
    
    it "should find card by bson id" do
      items = Rfid::Models::Card.with_keys(:bson => [@card2.id.to_s]).all
      items.should_not include @card
      items.should include @card2
    end
    
    it "should find cards by bson ids" do
      items = Rfid::Models::Card.with_keys(:bson => [@card.id.to_s, @card2.id.to_s]).all
      items.should include @card
      items.should include @card2
    end
    
    it "should find card by bson and uids" do
      items = Rfid::Models::Card.with_keys(:bson => [@card.id.to_s], :uids => [@card2.uid]).all
      items.size.should == 2
      items.should include @card
      items.should include @card2
    end
    
    it "should not find cards by not exists uid" do
      Rfid::Models::Card.with_keys(:uids => ['wrong']).all.should_not include @card
    end
    
    it "should parse cards" do
      items = Rfid::Models::Card.parse([@card.id.to_s, @card2.uid])
      
      items.size.should == 2
      items.should include @card
      items.should include @card2
    end
  end
end
