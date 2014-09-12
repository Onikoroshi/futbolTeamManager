class Player < ActiveRecord::Base
  has_many :stats, dependent: :destroy
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

  def player_stat(stat_type)
    found_stat = stat_type.present? ? stats.find_by(stat_type_id: stat_type.id, team_id: nil) : nil
    found_stat.nil? ? EmptyStat.new : found_stat
  end

  def team_stat(stat_type, team)
    found_stat = (stat_type.present? && team.present?) ? stats.find_by(stat_type_id: stat_type.id, team_id: team.id) : nil
    found_stat.nil? ? EmptyStat.new : found_stat
  end

  def team_stat_value(stat_type, team)
    team_stat(stat_type, team).value
  end

  def total_stat_value(stat_type)
    found_stats = self.stats.where(stat_type_id: stat_type.id)
    found_stats.to_a.inject(0){ |sum, stat| sum + stat.value }
  end

  private

  def build_combined_name
    self.combined_name = Manipulator.combine(first_name, last_name)
  end
end
