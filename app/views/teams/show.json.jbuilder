json.extract! @team, :id, :name, :created_at, :updated_at
json.array!(@team.players) do |player|
  json.extract! player, :id, :first_name, :last_name
  json.jersey @team.player_jersey(player)
  json.url player_url(player, format: :json)
end
