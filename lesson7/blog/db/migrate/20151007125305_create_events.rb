class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.datetime :started_at
      t.text :address
      t.text :content

      t.timestamps null: false
    end
  end
end
