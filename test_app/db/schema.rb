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

ActiveRecord::Schema.define(:version => 20111029185300) do

  create_table "comments", :force => true do |t|
    t.text     "content",                                                   :null => false
    t.integer  "depth"
    t.integer  "threaded_left"
    t.integer  "threaded_right"
    t.boolean  "is_deleted",                             :default => false, :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "thread"
    t.boolean  "approved",                               :default => false, :null => false
    t.boolean  "hidden_by_admin",                        :default => false, :null => false
    t.datetime "edited_at"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.integer  "content_sanitizer_version", :limit => 2, :default => 0,     :null => false
    t.integer  "pseud_id"
  end

  create_table "languages", :force => true do |t|
    t.string  "short",               :limit => 4
    t.string  "name"
    t.boolean "right_to_left",                    :default => false
    t.boolean "translation_visible",              :default => false
  end

  add_index "languages", ["short"], :name => "index_languages_on_short"

  create_table "otwtranslation_assignment_parts", :force => true do |t|
    t.integer  "assignment_id"
    t.integer  "position"
    t.integer  "user_id"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",        :limit => 3, :default => 0
  end

  create_table "otwtranslation_assignments", :force => true do |t|
    t.integer  "source_id"
    t.string   "language_short"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activated",      :default => false
  end

  create_table "otwtranslation_context_rules", :force => true do |t|
    t.string   "language_short"
    t.integer  "position"
    t.string   "type"
    t.string   "description"
    t.string   "conditions"
    t.string   "actions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "otwtranslation_phrases", :force => true do |t|
    t.string   "key"
    t.string   "label"
    t.string   "description"
    t.string   "version"
    t.integer  "translation_count"
    t.integer  "approved_translation_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "new",                        :default => true
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

  create_table "otwtranslation_translations", :force => true do |t|
    t.string   "label"
    t.boolean  "approved",       :default => false
    t.string   "phrase_key"
    t.string   "language_short"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rules"
  end

  create_table "otwtranslation_votes", :force => true do |t|
    t.integer  "translation_id"
    t.integer  "user_id"
    t.integer  "votes",          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pseuds", :force => true do |t|
    t.integer "user_id"
    t.string  "name",                          :null => false
    t.boolean "is_default", :default => false, :null => false
  end

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
