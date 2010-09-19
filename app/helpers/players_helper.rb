module PlayersHelper
  def display_website(player)
    player.website_url.split(/http(s)*\:\/\//).last.gsub(/\/$/, '').downcase
  end

  def sample_is?(number)
    @shot_sample == number
  end

  def viewing_players_tab?
    ! viewing_scouuuts_tab?
  end

  def viewing_scouuuts_tab?
    params[:view] == 'scouuuts'
  end

  def twitter_link(player)
    if player.twitter_screen_name
      twitter_user = player.twitter_screen_name.sub(/^.*[@\/]/, '')

      link_to(twitter_user, "http://twitter.com/#{twitter_user}")
    end
  end

  def possessive(player_name)
    if player_name.downcase.ends_with?('s')
      player_name + "'"
    else
      player_name + "'s"
    end
  end
end
