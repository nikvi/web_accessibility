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

ActiveRecord::Schema.define(version: 20140904023720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "category", id: false, force: true do |t|
    t.integer "category_id",                   null: false
    t.integer "page_id",                       null: false
    t.string  "category_name",     limit: 250
    t.string  "description_name",  limit: 250
    t.string  "description_title", limit: 250
    t.integer "count"
  end

  create_table "description", id: false, force: true do |t|
    t.string "name",    limit: 250, null: false
    t.string "title",   limit: 250
    t.string "type",    limit: 250
    t.string "summary", limit: 250
  end

  create_table "page", id: false, force: true do |t|
    t.integer "website_id",             null: false
    t.integer "page_id",                null: false
    t.string  "page_url",   limit: 250
    t.string  "page_title", limit: 250
    t.string  "wave_url",   limit: 250
  end

  create_table "report", id: false, force: true do |t|
    t.integer  "report_id",   null: false
    t.datetime "report_date"
    t.integer  "website_id",  null: false
  end

  create_table "website", force: true do |t|
    t.string   "url"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
