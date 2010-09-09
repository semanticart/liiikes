class PlayersController < ApplicationController
  PER_PAGE = 20

  def index
    @page = [params[:page].to_i, 1].max
    @players = Player.paginate(:page => @page, :per_page => PER_PAGE, :order => "laa desc", :include => :draftees)
  end
end
