module AboutHelper
  def freshness_time
    Player.first(:order => "updated_at desc").updated_at.in_time_zone('EST').strftime("%B %d, %Y @ %I:%M %p EST")
  end
end
