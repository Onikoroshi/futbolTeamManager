avail_teams = Team.pluck(:id)
Player.find_each do |player|
  chosen_teams = []
  (1 + Random.rand(2)).times do
    id = (avail_teams - chosen_teams).sample
    chosen_teams << id
    team = Team.find(id)
    team.add_player(player)
    team.assign_jersey(player)
  end

  puts "put player " + player.first_name + " on teams " + player.teams.map{|team| team.name + " | " + team.player_jersey(player)}.join(", ")
end
