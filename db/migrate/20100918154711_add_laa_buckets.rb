class AddLaaBuckets < ActiveRecord::Migration
  def self.up
    add_column :players, :laa_1, :decimal, :default => nil
    add_column :players, :laa_10, :decimal, :default => nil
    add_column :players, :laa_50, :decimal, :default => nil
    add_column :players, :laa_100, :decimal, :default => nil
  end

  def self.down
    remove_column :players, :laa_1
    remove_column :players, :laa_10
    remove_column :players, :laa_50
    remove_column :players, :laa_100
  end
end
