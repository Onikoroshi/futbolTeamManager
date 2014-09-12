class Player < ActiveRecord::Base
  has_many :stats
  has_many :teams_players, dependent: :destroy
  has_many :teams, through: :teams_players

  before_validation :build_combined_name

  validates :first_name, :last_name, presence: true
  validates :combined_name, uniqueness: { message: "Another player with a too-similar name already exists" }

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

  private

  def build_combined_name
    self.combined_name = Manipulator.combine(first_name, last_name)
  end
end
