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

  # only 1 level deep so far (intentionally)
  def calculate_laa(average_likes_per_shot = nil)
    average_likes_per_shot ||= Player.average_likes_per_shot

    draftees_attr = {:likes_received_count => 0, :shots_count => 0}

    draftees.inject(draftees_attr) do |hash, draftee|
      hash[:likes_received_count] ||= 0
      hash[:shots_count] ||= 0

      hash[:likes_received_count] += draftee.likes_received_count
      hash[:shots_count] += draftee.shots_count

      hash
    end

    # TODO: shouldn't this consider the number of draftees?
    if draftees_attr[:shots_count] > 0
      self.laa = (draftees_attr[:likes_received_count] / draftees_attr[:shots_count]) - average_likes_per_shot
    else
      self.laa = 0 - average_likes_per_shot
    end
  end

  def self.average_likes_per_shot
    likes = 0
    shots = 0

    Player.all(:conditions => "shots_count > 0", :select => [:likes_received_count, :shots_count]).each do |player|
      likes += player.likes_received_count
      shots += player.shots_count
    end

    likes / shots.to_f
  end
end
