class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.text :available_jerseys, default: []
      t.text :taken_jerseys, default: []

      t.timestamps
    end
  end
end
