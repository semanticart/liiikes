class Player < ActiveRecord::Base
  belongs_to :drafted_by, :class_name => 'Player', :foreign_key => :drafted_by_player_id

  has_many :draftees, :class_name => 'Player', :foreign_key => :drafted_by_player_id

  def self.from_api(swish_player)
    player = Player.find_by_id(swish_player.id) || begin
      Player.new do |player|
        player.id = swish_player.id
        player.save!
      end
    end

    player.compatible_attributes.each do |key|
      player.send("#{key}=", swish_player.send(key))
    end
    player.save!
  end

  def compatible_attributes
    attributes.keys - ['updated_at']
  end
end
