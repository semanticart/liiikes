class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :name
      t.string :url
      t.string :avatar_url
      t.string :location
      t.string :twitter_screen_name
      t.integer :drafted_by_player_id
      t.integer :shots_count
      t.integer :draftees_count
      t.integer :followers_count
      t.integer :following_count
      t.timestamp :d_created_at    
      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
