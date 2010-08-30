class Player < ActiveRecord::Base
  belongs_to :drafted_by, :class_name => 'Player', :foreign_key => :drafted_by_player_id

  has_many :draftees, :class_name => 'Player', :foreign_key => :drafted_by_player_id
end
