PLAYER_RANK_SQL = %(
  update players set player_rank_# = ranks.rank from
    (
      SELECT
         p1.id, p1.personal_laa, COUNT(p2.id) AS rank
      FROM
         players p1, players p2
      WHERE
        p2.personal_laa >= p1.personal_laa
        and p1.shots_count >= # and p2.shots_count >= #
      GROUP BY
        p1.id, p1.personal_laa
      ORDER BY rank
    )
    as ranks
  where ranks.id = players.id;
)

LAA_RANK_SQL = %(
  update players set laa_rank_# = ranks.rank from
    (
      SELECT
         p1.id, p1.laa_#, COUNT(p2.id) AS rank
      FROM
         players p1, players p2
      WHERE
        p2.laa_# >= p1.laa_#
      GROUP BY
        p1.id, p1.laa_#
      ORDER BY rank
    )
    as ranks
  where ranks.id = players.id
)

task :update_ranks => :environment do
  puts "updating ranks"
  SAMPLE_SIZES.each do |size|
    puts "handling size = #{size}"
    Player.connection.execute(PLAYER_RANK_SQL.gsub(/\#/, size.to_s))
    Player.connection.execute(LAA_RANK_SQL.gsub(/\#/, size.to_s))
  end
end

task :calculate_laas => :environment do
  puts "calculating laas"
  # calculate the laas
  average_likes_per_shot = Player.average_likes_per_shot
  Player.transaction do
    Player.all(:include => :draftees).each do |player|
      player.calculate_laa(average_likes_per_shot)
      player.calculate_personal_laa(average_likes_per_shot)

      # ensure that one way or another we're updating this record
      if player.changed?
        player.save!
      else
        player.touch
      end
    end
  end
end

task :scrape_players => :environment do
  require 'swish'

  players = []
  players << Dribbble::Player.find(1)
  players << Dribbble::Player.find(2)

  api_requests = 0

  Player.transaction do
    players.each do |player|
      Player.from_api(player)
    end

    while players.size > 0 do
      puts "working with #{players.size} players"
      player = players.shift
      draftees_count = player.draftees_count

      page_number = 1
      while draftees_count > 0
        puts "---pulling page #{page_number} with #{draftees_count} remaining draftees"
        draftees = player.draftees(:page => page_number, :per_page => 30)
        api_requests += 1
        draftees_count -= draftees.size

        break if draftees.size == 0

        draftees.each do |draftee|
          Player.from_api(draftee)
          players << draftee if draftee.draftees_count > 0
        end
        page_number += 1
        sleep 1
      end
    end
  end
  puts "done in #{api_requests} api requests"
end

task :refresh => [:scrape_players, :calculate_laas, :update_ranks]do
  puts "done refreshing"
end

task :clear_prod_cache do
  require 'fileutils'
  FileUtils.rm_rf "#{Rails.root}/public/players/" rescue puts "failed to delete players/"
  FileUtils.rm_rf "#{Rails.root}/public/scouts/" rescue puts "failed to delete scouts/"
  FileUtils.rm "#{Rails.root}/public/about.html" rescue puts "failed to delete about.html"
  FileUtils.rm "#{Rails.root}/public/index.html" rescue puts "failed to delete index.html"
end

# desc "This task is called by the Heroku cron add-on"
# task :cron => [:scrape_players] do
#   puts "done cronning"
# end
