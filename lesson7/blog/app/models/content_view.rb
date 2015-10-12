# == Schema Information
#
# Table name: content_views
#
#  id         :integer          primary key
#  title      :string
#  type       :text
#  slug       :string
#  started_at :datetime
#  address    :text
#  tag_ids    :integer          is an Array
#  created_at :datetime
#  updated_at :datetime
#
class ContentView < ActiveRecord::Base
  self.table_name = "content_views"
  self.primary_key = "id"

  scope :any_tags, -> (tags) { where('tag_ids && ARRAY[?]', Array.wrap(tags).map(&:to_i)) }
  scope :recently, -> { order(created_at: :desc) }

  # Prevent creation of new records and modification to existing records
  #
  def readonly?     
    return true
  end

  # Prevent objects from being destroyed
  #
  def before_destroy
    raise ActiveRecord::ReadOnlyRecord
  end
end
