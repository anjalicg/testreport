# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091022085203) do

  create_table "builds", :force => true do |t|
    t.string "name"
  end

  create_table "releases", :force => true do |t|
    t.string   "serial"
    t.datetime "created_at"
    t.date     "start_date"
    t.string   "doc"
  end

  create_table "testcases", :force => true do |t|
    t.string  "testcase_id"
    t.string  "testdescription"
    t.integer "serial"
    t.integer "build_id"
    t.string  "steps"
    t.string  "output"
    t.string  "profile"
  end

  create_table "testplans", :force => true do |t|
    t.string   "testcase_id"
    t.string   "description"
    t.string   "included"
    t.integer  "build_id"
    t.string   "reported_by"
    t.datetime "created_at"
  end

  create_table "testreports", :force => true do |t|
    t.string  "executed_by"
    t.string  "result"
    t.text    "observation"
    t.text    "deviations"
    t.integer "build_id"
    t.integer "testcase_id"
    t.integer "release_id"
    t.date    "updated_at"
  end

end
