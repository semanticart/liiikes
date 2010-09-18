class PlayersController < ApplicationController
  PER_PAGE = 20

  def index
    @page = [params[:page].to_i, 1].max
    @players = Player.paginate({:page => @page, :per_page => PER_PAGE}.merge(options_from_params))

    @template = template_from_params

    respond_to do |format|
      format.js { render :partial => @template_from_params }
      format.html { }
    end
  end

  protected

  def options_from_params
    case params[:view]
    when 'scouuuts'
      {:order => "laa_#{@shot_sample} desc, id asc", :include => :draftees, :conditions => "players.laa_#{@shot_sample} IS NOT NULL"}
    else
      {:order => "personal_laa desc, id asc", :conditions => ["shots_count >= ?", @shot_sample]}
    end
  end

  def template_from_params
    case params[:view]
    when 'scouuuts'
      'scouuuts'
    else
      'liiikes'
    end
  end
end
