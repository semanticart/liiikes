class PlayersController < ApplicationController
  PER_PAGE = 20
  before_filter :enforce_defaults, :only => :index
  before_filter :set_shot_sample, :only => :index
  caches_page :index, :show

  def index
    @page = [params[:page].to_i, 1].max
    @players = Player.paginate({:page => @page, :per_page => PER_PAGE}.merge(options_from_params))

    @template = template_from_params

    respond_to do |format|
      format.js { render :partial => @template_from_params }
      format.html { }
    end
  end

  def show
    @player = Player.find_by_login(params[:id])
  end

  protected

  def options_from_params
    case params[:view]
    when 'scouts'
      {:order => "laa_#{@shot_sample} desc, id asc", :include => :"draftees_#{@shot_sample}", :conditions => "players.laa_#{@shot_sample} IS NOT NULL"}
    else
      {:order => "personal_laa desc, id asc", :conditions => ["shots_count >= ?", @shot_sample]}
    end
  end

  def template_from_params
    case params[:view]
    when 'scouts'
      'scouts'
    else
      'liiikes'
    end
  end

  def enforce_defaults
    params[:view] = 'players' unless params[:view] == 'scouts'
    params[:shot_sample] = '10' unless SAMPLE_SIZES.include?(params[:shot_sample].to_i)
  end

  def set_shot_sample
    @shot_sample = params[:shot_sample].to_i
  end
end
