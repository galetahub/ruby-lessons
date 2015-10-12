# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151007132213) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "title",                   null: false
    t.datetime "started_at"
    t.text     "address"
    t.text     "content"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "tag_ids",    default: [],              array: true
  end

  add_index "events", ["tag_ids"], name: "index_events_on_tag_ids", using: :gin

  create_table "posts", force: :cascade do |t|
    t.string   "title",                    null: false
    t.string   "slug"
    t.string   "author_name"
    t.text     "content"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "tag_ids",     default: [],              array: true
  end

  add_index "posts", ["tag_ids"], name: "index_posts_on_tag_ids", using: :gin

  create_table "tags", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["slug"], name: "index_tags_on_slug", unique: true, using: :btree

end
