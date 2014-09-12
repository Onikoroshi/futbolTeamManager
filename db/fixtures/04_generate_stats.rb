Team.find_each do |team|
  puts "Team: " + team.name

  team.players.find_each do |player|
    puts "\tPlayer: " + player.full_name

    StatType.find_each do |stat_type|
      value = 1 + rand(20)
      team.update_player_stat(stat_type, player, value)

      puts "\t\t" + value.to_s + " " + stat_type.name
    end
  end
end
