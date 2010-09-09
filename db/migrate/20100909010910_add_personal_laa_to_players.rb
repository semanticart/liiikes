class AddPersonalLaaToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :personal_laa, :decimal
  end

  def self.down
    remove_column :players, :personal_laa
  end
end
