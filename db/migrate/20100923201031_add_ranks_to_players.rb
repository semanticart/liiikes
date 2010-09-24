class AddRanksToPlayers < ActiveRecord::Migration
  SIZES = [1,10,50,100]

  def self.up
    SIZES.each do |size|
      add_column :players, :"player_rank_#{size}", :integer
      add_column :players, :"laa_rank_#{size}", :integer
    end
  end

  def self.down
    SIZES.each do |size|
      remove_column :players, :"player_rank_#{size}"
      remove_column :players, :"laa_rank_#{size}"
    end
  end
end
