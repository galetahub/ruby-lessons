class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug
      t.string :author_name
      t.text :content
      t.timestamps null: false
    end
  end
end
