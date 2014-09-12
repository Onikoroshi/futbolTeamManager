class Team < ActiveRecord::Base
  has_many :stats
  has_many :teams_players, dependent: :destroy
  has_many :players, through: :teams_players

  serialize :available_jerseys
  serialize :taken_jerseys

  before_validation :update_available_jerseys, :build_combined_name

  validates :name, :combined_name, presence: true
  validates :combined_name, uniqueness: { message: "Another team with a too-similar name already exists" }

  before_destroy :merge_stats

  def team_player(player)
    found_player = player.present? ? teams_players.find_by(player_id: player.id) : nil

    found_player.present? ? found_player : EmptyTeamsPlayer.new
  end

  def add_player(player, jersey = nil)
    teams_players << TeamsPlayer.create(team_id: self.id, player_id: player.id, jersey: (jersey.blank? ? "" : take_jersey(jersey))) if player.present?
  end

  def remove_player(player)
    if player.present?
      unassign_jersey(player)
      team_player(player).destroy
    end
  end

  def player_jersey(player)
    team_player(player).jersey
  end

  def assign_jersey(player, jersey = nil)
    jerseys_were_available = available_jerseys.any?
    given_jersey = take_jersey(jersey)

    unless team_player(player).update_attributes(jersey: given_jersey)
      return_jersey(given_jersey, jerseys_were_available)
    end
  end

  def unassign_jersey(player)
    found_player = team_player(player)

    return_jersey(found_player.jersey)
    found_player.update_attributes(jersey: "")
  end

  def player_stat_value(stat_type, player)
    get_player_stat_object(stat_type, player).value
  end

  def update_player_stat(stat_type, player, value)
    build_player_stat_object(stat_type, player).update_attributes(value: value)
  end

  def decrement_player_stat(stat_type, player)
    build_player_stat_object(stat_type, player).decrement
  end

  def increment_player_stat(stat_type, player)
    build_player_stat_object(stat_type, player).increment
  end

  def empty_team?
    false
  end

  private

  def build_player_stat_object(stat_type, player)
    stat_obj = (self.players.include?(player) && stat_type.present? && player.present?) ? stats.where(stat_type_id: stat_type.id, team_id: self.id, player_id: player.id).first_or_create : nil
    (stat_obj.present? && stat_obj.valid?) ? stat_obj : EmptyStat.new
  end

  def get_player_stat_object(stat_type, player)
    found_stat = (self.players.include?(player) && stat_type.present? && player.present?) ? stats.find_by(stat_type_id: stat_type.id, team_id: self.id, player_id: player.id) : nil
    found_stat.present? ? found_stat : EmptyStat.new
  end

  def take_jersey(given_jersey = nil)
    chosen_jersey = ""

    unless given_jersey.blank?
      chosen_jersey = given_jersey
    else
      chosen_jersey = available_jerseys.any? ? available_jerseys.sample : random_untaken_jersey
    end

    available_jerseys.delete(chosen_jersey)
    add_to_pile(taken_jerseys, chosen_jersey)
    save

    chosen_jersey.to_s
  end

  def random_untaken_jersey
    to_try = rand(20).to_s.rjust(2, "0")
    while taken_jerseys.include?(to_try)
      to_try = (to_try.to_i + 1).to_s.rjust(2, "0")
    end
    to_try
  end

  def return_jersey(jersey, jerseys_were_available = true)
    if !jersey.blank? && taken_jerseys.include?(jersey)
      taken_jerseys.delete(jersey)
      add_to_pile(available_jerseys, jersey) if jerseys_were_available
      save
    end
  end

  def add_to_pile(pile, jersey)
    pile << jersey
    pile.reject!(&:empty?)
    pile.uniq!
    pile.sort!
  end

  def update_available_jerseys
    if available_jerseys_changed? and available_jerseys.is_a?(String)
      self.available_jerseys = self.available_jerseys.split(',').collect(&:strip)
    end
  end

  def build_combined_name
    self.combined_name = Manipulator.combine(self.name)
  end

  # When we delete a team, we don't want to lose all the stats the player accumulated while on that team.
  # However, when an orphaned stat already exists, we can't have a duplicate, so we add what the player got from this team
  # to what they already have in the orphaned stat.
  def merge_stats
    # player_ids has already been destroyed
    destinations = Stat.where(player_id: self.stats.pluck(:player_id).uniq, team_id: nil) # all the orphaned stats
    stats_to_merge = self.stats.where(player_id: destinations.pluck(:player_id), stat_type: destinations.pluck(:stat_type_id)) # all this team's player's stats that match the orphaned stats

    stats_to_merge.each do |to_merge|
      destination = destinations.find_by(player_id: to_merge.player_id, stat_type_id: to_merge.stat_type_id)
      destination.add_to(to_merge.value.to_f)
      to_merge.destroy # make sure we destroy the team's player's stat at the end
    end

    # Destroying a team is not automatically setting the "team_id" in the join table to nil
    # So, do that for all stats still associated with this team.
    self.stats.map{ |stat| stat.update_attributes(team_id: nil) }
  end
end
