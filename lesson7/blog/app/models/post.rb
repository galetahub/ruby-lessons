# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  slug        :string
#  author_name :string
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tag_ids     :integer          default([]), is an Array
#
# Indexes
#
#  index_posts_on_tag_ids  (tag_ids)
#

class Post < ActiveRecord::Base
  validates :title, presence: true

  def to_param
    "#{slug}-#{id}"
  end
end
