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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110315173000) do

  create_table "languages", :force => true do |t|
    t.string  "short",                :limit => 4
    t.string  "name"
    t.boolean "right_to_left",                     :default => false
    t.boolean "translation_visible",              :default => false
  end

  add_index "languages", ["short"], :name => "index_languages_on_short"

  create_table "otwtranslation_phrases", :force => true do |t|
    t.string   "key"
    t.string   "label"
    t.string   "description"
    t.string   "language"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "otwtranslation_phrases", ["key"], :name => "index_otwtranslation_phrases_on_key", :unique => true

  create_table "otwtranslation_phrases_sources", :id => false, :force => true do |t|
    t.integer "phrase_id"
    t.integer "source_id"
  end

  create_table "otwtranslation_sources", :force => true do |t|
    t.string   "controller_action"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "otwtranslation_sources", ["controller_action"], :name => "index_otwtranslation_sources_on_controller_action", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "login"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "persistence_token"
    t.boolean  "translation_admin", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
