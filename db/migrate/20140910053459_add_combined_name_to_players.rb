class AddCombinedNameToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :combined_name, :string
  end
end
