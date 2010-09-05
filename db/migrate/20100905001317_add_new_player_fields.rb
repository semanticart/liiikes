class AddNewPlayerFields < ActiveRecord::Migration
  NEW_FIELDS = [:comments_count, :comments_received_count, :likes_count, :likes_received_count, :rebounds_count, :rebounds_received_count]
  def self.up
    NEW_FIELDS.each do |field|
      add_column :players, field, :integer, :default => 0
    end
  end

  def self.down
    NEW_FIELDS.each do |field|
      remove_column :players, field
    end
  end
end
