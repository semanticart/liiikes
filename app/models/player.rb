class Player < ActiveRecord::Base
  belongs_to :drafted_by, :class_name => 'Player', :foreign_key => :drafted_by_player_id

  has_many :draftees, :class_name => 'Player', :foreign_key => :drafted_by_player_id, :order => "personal_laa desc"

  SAMPLE_SIZES.each do |size|
    has_many :"draftees_#{size}",
      :class_name => 'Player',
      :foreign_key => :drafted_by_player_id,
      :order => "personal_laa desc",
      :conditions => "players.shots_count >= #{size}"
  end

  def self.find_by_login(login)
    find_by_url("http://dribbble.com/#{login}")
  end

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

    player.name = player.dribbble_login if player.name.blank?

    player.save!
  end

  def dribbble_login
    url.split('/').last
  end

  def to_param
    dribbble_login
  end

  def compatible_attributes
    attributes.keys - (['updated_at', 'laa', 'personal_laa'] + SAMPLE_SIZES.map{|size| ["laa_#{size}", "player_rank_#{size}", "laa_rank_#{size}"]}.flatten)
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
    laas = draftees.inject(Hash.new(0)) do |h, draftee|
      h[:laa] += draftee.calculate_personal_laa(average_likes_per_shot)
      SAMPLE_SIZES.each do |size|
        h[:"laa_#{size}"] += draftee.calculate_personal_laa(average_likes_per_shot) if draftee.shots_count >= size
      end
      h
    end

    laas.each_pair do |key, value|
      self.send(:"#{key}=", value)
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

  def draftees_for_sample(shot_sample = 0)
    if shot_sample.to_i > 0
      send(:"draftees_#{shot_sample}")
    else
      draftees
    end
  end

  # TODO: make these 3 methods performant.  but it doesn't really matter since they're fast enough given caching.
    def draftee_likes_received_count(shot_sample = 0)
      draftees_for_sample(shot_sample).inject(0){|sum, draftee| sum + draftee.likes_received_count}
    end

    def draftee_shots_count(shot_sample = 0)
      draftees_for_sample(shot_sample).inject(0){|sum, draftee| sum + draftee.shots_count}
    end

    def draftee_total_laa(shot_sample = 0)
      draftees_for_sample(shot_sample).inject(0){|sum, draftee| sum + draftee.personal_laa}
    end
end
