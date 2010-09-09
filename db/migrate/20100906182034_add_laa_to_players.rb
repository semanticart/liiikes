class AddLaaToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :laa, :decimal
  end

  def self.down
    remove_column :players, :laa
  end
end
