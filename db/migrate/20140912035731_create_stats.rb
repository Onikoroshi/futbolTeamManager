class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.references :player, index: true
      t.references :team, index: true
      t.decimal :value

      t.timestamps
    end
  end
end
