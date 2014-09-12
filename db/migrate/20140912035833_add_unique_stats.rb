class AddUniqueStats < ActiveRecord::Migration
  def change
    add_index(:stats, [:player_id, :team_id, :stat_type_id], unique: true)
  end
end
