# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  started_at :datetime
#  address    :text
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_ids    :integer          default([]), is an Array
#
# Indexes
#
#  index_events_on_tag_ids  (tag_ids)
#

class Event < ActiveRecord::Base
  validates :title, presence: true
end
