module DeviceHelper

  def create_device(attrs = {})
    attrs = { :latitude => 45.56757, :longitude => 43.34234 }.merge(attrs)
    Rfid::Models::Device.create(attrs)
  end
  
  def create_card(attrs = {})
    attrs = { :uid => Rfid.friendly_token, :role_type => 1 }.merge(attrs)
    Rfid::Models::Card.create(attrs)
  end
  
  def create_social_account(attrs = {})
    attrs = {:uid => '2592709',
      :provider => 'vkontakte',
      :namespace => 'test',
      :auth_hash => {"user_info"=>{"name"=>"Павел Галета", "location"=>", ", "urls"=>{"Vkontakte"=>"http://vkontakte.ru/id2592709"}, "nickname"=>"", "birth_date"=>"10.3.1987", "last_name"=>"Галета", "image"=>"http://cs10901.vkontakte.ru/u2592709/e_f8b6e3b9.jpg", "first_name"=>"Павел"}, "uid"=>2592709, "credentials"=>{"token"=>"7a1cfdd37a3b72167a3b7216ac7a1347bde7a3b7a3a7216c95a735a210be6d4"}, "extra"=>{"user_hash"=>{"timezone"=>2, "gender"=>"2", "photo_big"=>"http://cs10901.vkontakte.ru/u2592709/a_d8f124ce.jpg"}}, "provider"=>"vkontakte"}
    }.merge(attrs)
    
    Rfid::Models::SocialAccount.create(attrs)
  end
  
  # Params
  # cards - array of card ids
  # time - current event time in format: yyyyMMddhhmmss
  # hash - md5(id, secret_key, cards.sort.join, time)
  # mode - "recently" or "delayed" (1 or 2)
  #
  def events_attrs(device, attrs = {})
    attrs = { 
      :cards => [], 
      :time => Time.now.utc.strftime(Rfid::Models::Event::TIME_FORMAT),
      :mode => "recently"
    }.merge(attrs)
    
    attrs[:hash] ||= device.secret_hash( attrs[:cards].map(&:to_s).sort.join, attrs[:time] )
    attrs
  end
  
  def init_event_with_cards
    @device = Rfid::Models::Device.create({ :latitude => 45.56757, :longitude => 43.34234 })
    @action = @device.actions.first
    @card1 = create_card
    @card2 = create_card
    
    @attrs = events_attrs(@device, { :cards => [@card2.id, @card1.id] })
    @event = @device.events.build(:params => @attrs)
  end
end
