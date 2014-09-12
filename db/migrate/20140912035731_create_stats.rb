class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.references :player, index: true
      t.references :team, index: true
      t.references :stat_type, index: true
      t.decimal :value, default: 0

      t.timestamps
    end
  end
end
