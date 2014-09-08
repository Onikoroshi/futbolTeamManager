class Player < ActiveRecord::Base
  has_many :stats
  has_many :teams_players, dependent: :destroy
  has_many :teams, through: :teams_players

  def full_name
    [first_name, last_name].reject(&:empty?).join(" ")
  end

  def player_team(team)
    team.present? ? teams_players.find_by(team_id: team.id) : nil
  end

  def team_jersey(team)
    found_team = player_team(team)
    found_team.present? ? found_team.jersey : ""
  end
end
