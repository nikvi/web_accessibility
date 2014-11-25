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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  #enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.integer "page_id",                       null: false
    t.string  "category_name",     limit: 250
    t.string  "description_name",  limit: 250
    t.string  "description_title", limit: 250
    t.integer "count"
  end

  create_table "descriptions", force: true do |t|
    t.string "name",    limit: 250
    t.string "title",   limit: 250
    t.string "type",    limit: 250
    t.string "summary", limit: 250
  end

  create_table "pages", force: true do |t|
    t.integer "report_id",              null: false
    t.string  "page_url",   limit: 250
    t.string  "page_title", limit: 250
    t.string  "wave_url",   limit: 250
  end

  create_table "reports", force: true do |t|
    t.datetime "report_date"
    t.integer  "website_id",   null: false
    t.integer  "pages_total"
    t.integer  "pages_error"
    t.integer  "total_errors"
    t.integer  "total_alerts"
  end

  create_table "submits", force: true do |t|
    t.string   "web_url",     limit: 250, null: false
    t.string   "report_name", limit: 250
    t.datetime "submit_date"
  end

  create_table "websites", force: true do |t|
    t.string "website_url",  limit: 250
    t.string "website_name", limit: 250
  end

end
