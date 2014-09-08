class UniqueTeamsPlayers < ActiveRecord::Migration
  def change
    add_index(:teams_players, [:player_id, :team_id], unique: true)
  end
end
