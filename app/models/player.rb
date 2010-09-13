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
    attributes.keys - ['updated_at', 'laa', 'personal_laa']
  end

  def calculate_personal_laa(average_likes_per_shot)
    self.personal_laa = if shots_count == 0
      0
    else
      likes_received_count / shots_count.to_f - average_likes_per_shot
    end
  end

  # only 1 level deep so far (intentionally)
  def calculate_laa(average_likes_per_shot = Player.average_likes_per_shot)
    self.laa = draftees.inject(0) do |sum, draftee|
      sum + draftee.calculate_personal_laa(average_likes_per_shot)
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

  # TODO: make these 2 methods performant
    def scouuuts_likes_received_count
      draftees.inject(0){|sum, draftee| sum + draftee.likes_received_count}
    end

    def scouuuts_shots_count
      draftees.inject(0){|sum, draftee| sum + draftee.shots_count}
    end
end
