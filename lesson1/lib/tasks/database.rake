namespace :db do

  desc 'Create the indexes defined on your mongoid models'
  task :create_indexes do
    Rfid::Models::Card.create_indexes
  end

  desc 'Drops all the collections for the database for the current Rails.env'
  task :drop => :environment do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each { |c| c.drop }
  end
end