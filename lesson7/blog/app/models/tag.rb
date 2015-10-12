# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_slug  (slug) UNIQUE
#

class Tag < ActiveRecord::Base
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
