class CreateStatTypes < ActiveRecord::Migration
  def change
    create_table :stat_types do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end
end
