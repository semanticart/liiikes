class PlayersController < ApplicationController
  def index
    # TODO: this should order by rank
    @players = Player.paginate(:page => 1, :per_page => 20, :order => "id asc", :include => :draftees)
  end
end
