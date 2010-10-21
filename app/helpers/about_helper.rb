module AboutHelper
  # return the formatted time of the oldest updated player
  def freshness_time
    Player.first(:order => "updated_at asc").
      updated_at.in_time_zone('EST').strftime("%B %d, %Y @ %I:%M %p EST")
  end
end
