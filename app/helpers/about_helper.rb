module AboutHelper
  def freshness_time
    Player.first(:order => "updated_at desc").updated_at.strftime("%B %d, %Y @ %I:%M %p EST")
  end
end
