module PlayersHelper
  # trim the http:// and trailing slashes from someone's url
  def display_website(player)
    player.website_url.split(/http(s)*\:\/\//).last.gsub(/\/$/, '').downcase
  end

  # helper to determine if we're using the provided shot sample
  def sample_is?(number)
    @shot_sample == number
  end

  # are we viewing the scouts' tab?
  def viewing_scouts_tab?
    params[:view] == 'scouts'
  end

  # are we viewing the player's tab?
  def viewing_players_tab?
    ! viewing_scouts_tab?
  end

  # provide a link to twitter based on someone's twitter name
  def twitter_link(player)
    if player.twitter_screen_name
      # clean up any bad characters in a player's twitter name
      twitter_user = player.twitter_screen_name.sub(/^.*[@\/]/, '')

      link_to(twitter_user, "http://twitter.com/#{twitter_user}")
    end
  end

  # helper to make a name possessive
  def possessive(player_name)
    if player_name.downcase.ends_with?('s')
      player_name + "'"
    else
      player_name + "'s"
    end
  end
end
