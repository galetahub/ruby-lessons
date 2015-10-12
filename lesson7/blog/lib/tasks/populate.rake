require 'populator'

namespace :populate do
  desc "Create random posts"
  task :posts => [:environment] do
    Post.populate(100..200) do |post|
      post.title = Populator.words(10..20)
      post.content = Populator.paragraphs(3..4)
      post.author_name = Faker::Name.name
      post.slug = Faker::Internet.slug(post.title, '-')
    end
  end

  desc "Create random events"
  task :events => [:environment] do
    Event.populate(50..100) do |event|
      event.title = Populator.words(10..20)
      event.content = Populator.paragraphs(3..4)
      event.address = Faker::Address.city
      event.started_at = Faker::Date.between(2.days.ago, 100.days.from_now)
    end
  end
end