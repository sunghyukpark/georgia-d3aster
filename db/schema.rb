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

ActiveRecord::Schema.define(version: 20160315001922) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hazards", force: :cascade do |t|
    t.string   "name"
    t.string   "hazard_type_combo"
    t.string   "postal_code"
    t.integer  "injuries"
    t.integer  "fatalities"
    t.integer  "property_damage"
    t.integer  "crop_damage"
    t.integer  "hazard_id"
    t.integer  "fips_code"
    t.datetime "hazard_begin_date"
    t.datetime "hazard_end_date"
    t.string   "remarks"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

end
