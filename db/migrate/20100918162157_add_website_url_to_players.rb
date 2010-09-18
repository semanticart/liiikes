class AddWebsiteUrlToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :website_url, :string
  end

  def self.down
    remove_column :players, :website_url
  end
end
