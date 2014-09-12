class AddCombinedNameToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :combined_name, :string
  end
end
