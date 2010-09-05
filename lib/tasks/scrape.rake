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
