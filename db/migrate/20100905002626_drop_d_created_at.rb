class DropDCreatedAt < ActiveRecord::Migration
  def self.up
    remove_column :players, :d_created_at
  end

  def self.down
    add_column :players, :d_created_at, :timestamp
  end
end
