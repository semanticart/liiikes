class PlayersController < ApplicationController
  PER_PAGE = 20
  before_filter :enforce_defaults, :only => :index
  before_filter :get_players_per_sample, :only => :show
  caches_page :index, :show

  # index which shows either the scouts or liiikes view
  def index
    # set our shot sample size
    @shot_sample = params[:shot_sample].to_i
    # get the page number or default to 1
    @page = [params[:page].to_i, 1].max
    # paginate players based on `options_from_params`
    @players = Player.paginate({:page => @page, :per_page => PER_PAGE}.merge(options_from_params))

    # choose our template
    @template = template_from_params
  end

  # show a specific player
  def show
    # find the player by their login
    @player = Player.find_by_login(params[:id])
    # 404 if player isn't found
    raise ActiveRecord::RecordNotFound unless @player
  end

  protected

  # the scouts view and liiikes view have separate orders, inclusions, and conditions
  def options_from_params
    case params[:view]
    when 'scouts'
      {:order => "laa_#{@shot_sample} desc, id asc", :include => :"draftees_#{@shot_sample}", :conditions => "players.laa_#{@shot_sample} IS NOT NULL"}
    else
      {:order => "personal_laa desc, id asc", :conditions => ["shots_count >= ?", @shot_sample]}
    end
  end

  # our template is determined by the view (which is passed in via our routes)
  def template_from_params
    case params[:view]
    when 'scouts'
      'scouts'
    else
      'liiikes'
    end
  end

  # if shot_sample or view is not provided, use a default
  def enforce_defaults
    params[:view] = 'players' unless params[:view] == 'scouts'
    params[:shot_sample] = '10' unless SAMPLE_SIZES.include?(params[:shot_sample].to_i)
  end

  # cache the number of players who have a rank and an laa_rank in a particular shot_size
  def get_players_per_sample
    @players_per_sample = Rails.cache.fetch('pps', :expires_in => 5.minutes) do
      SAMPLE_SIZES.inject({}) do |h, size|
        h[size] ||= {}
        h[size][:p] = Player.count(:conditions => "player_rank_#{size} IS NOT NULL")
        h[size][:l] = Player.count(:conditions => "laa_rank_#{size} IS NOT NULL")
        h
      end
    end
  end
end
