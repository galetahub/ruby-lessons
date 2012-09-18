namespace :api do
  desc 'Create action for device'
  task :action => :environment do
    device = Rfid::Models::Device.find(ENV['id'])
    device.send(:create_action)
  end
  
  namespace :social_accounts do
    desc 'Clear accounts without cards'
    task :clear => :environment do
      puts "Total count: #{Rfid::Models::SocialAccount.count}"
      
      Rfid::Models::SocialAccount.all.each do |account|
        account.destroy if account.cards.count.zero?
      end
      
      puts "Left: #{Rfid::Models::SocialAccount.count}"
    end
  
    desc 'Destroy social account'
    task :destroy => :environment do
      account = Rfid::Models::SocialAccount.find(ENV['id'])
      account.destroy
    end
  end
end
