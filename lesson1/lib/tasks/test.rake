namespace :test do
  desc 'Create new devise, action'
  task :populate => :environment do
    card = Rfid::Models::Card.create!(:uid => 'test', :role_type => 1)
    d = Rfid::Models::Device.create!(:latitude => 50.7, :longitude => 30.5)
    
    attrs = { 
      :cards => [card.id.to_s], 
      :time => Time.now.strftime(Rfid::Models::Event::TIME_FORMAT),
      :mode => "recently",
    }
    
    attrs[:hash] = d.secret_hash( attrs[:cards].sort.join, attrs[:time] )
    
    d.relays.create!(:title => 'Green', :info => 'test')
    d.actions.create!(:title => 'Default', :klass_name => 'DefaultAction')
    d.events.create!(:params => attrs)
  end
end
