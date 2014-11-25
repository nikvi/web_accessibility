class InitialMigration < ActiveRecord::Migration
  def change
  	enable_extension "plpgsql"

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
end
