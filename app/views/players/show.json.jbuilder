json.extract! @player, :id, :first_name, :last_name, :created_at, :updated_at
json.array!(@player.teams) do |team|
  json.extract! team, :id, :name
  json.jersey @player.team_jersey(team)
  json.url team_url(team, format: :json)
end
