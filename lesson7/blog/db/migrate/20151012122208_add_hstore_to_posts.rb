class AddHstoreToPosts < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION IF NOT EXISTS hstore;"

    add_column :posts, :settings, :hstore, default: '', null: false
  end

  def down
    execute "DROP EXTENSION IF EXISTS hstore;"
  end
end
