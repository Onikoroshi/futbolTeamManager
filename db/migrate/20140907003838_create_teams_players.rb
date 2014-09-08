class CreateTeamsPlayers < ActiveRecord::Migration
  def change
    create_table :teams_players do |t|
      t.references :team, index: true
      t.references :player, index: true
      t.string :jersey

      t.timestamps
    end
  end
end
