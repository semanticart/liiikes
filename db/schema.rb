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

ActiveRecord::Schema.define(:version => 20100909010910) do

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "avatar_url"
    t.string   "location"
    t.string   "twitter_screen_name"
    t.integer  "drafted_by_player_id"
    t.integer  "shots_count"
    t.integer  "draftees_count"
    t.integer  "followers_count"
    t.integer  "following_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count",          :default => 0
    t.integer  "comments_received_count", :default => 0
    t.integer  "likes_count",             :default => 0
    t.integer  "likes_received_count",    :default => 0
    t.integer  "rebounds_count",          :default => 0
    t.integer  "rebounds_received_count", :default => 0
    t.decimal  "laa"
    t.decimal  "personal_laa"
  end

end
