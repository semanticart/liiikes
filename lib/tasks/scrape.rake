task :scrape_players => :environment do
  require 'swish'

  players = []
  players << Dribbble::Player.find(1)
  players << Dribbble::Player.find(2)

  api_requests = 0

  players.each do |player|
    Player.from_api(player)
  end

  while players.size > 0 do
    begin
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
    rescue => ex
      require 'ruby-debug'
      debugger
      puts "uh oh"
    end
  end

  puts "done in #{api_requests} api requests"
end


task :calculate_laas => :environment do
  average_likes_per_shot = Player.average_likes_per_shot
  Player.transaction do
    Player.all(:include => :draftees).each do |player|
      puts "handling #{player.id}"
      player.calculate_laa(average_likes_per_shot)
      player.calculate_personal_laa(average_likes_per_shot)
      player.save!
    end
  end
end

task :clear_prod_cache do
  require 'fileutils'
  FileUtils.rm_rf "#{Rails.root}/public/players/" rescue puts "failed to delete players/"
  FileUtils.rm_rf "#{Rails.root}/public/scouts/" rescue puts "failed to delete scouts/"
  FileUtils.rm "#{Rails.root}/public/about.html" rescue puts "failed to delete about.html"
  FileUtils.rm "#{Rails.root}/public/index.html" rescue puts "failed to delete index.html"
end
