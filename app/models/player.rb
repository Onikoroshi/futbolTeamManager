class Player < ActiveRecord::Base
  has_many :stats
  has_many :teams_players, dependent: :destroy
  has_many :teams, through: :teams_players

  before_validation :build_combined_name

  validates :first_name, :last_name, presence: true
  validates :combined_name, uniqueness: true

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
    puts "first name: " + first_name.to_s
    puts "last name: " + last_name.to_s
    self.combined_name = self.first_name.to_s.downcase + self.last_name.downcase.to_s
  end
end
