class Team < ActiveRecord::Base
  has_many :stats
  has_many :teams_players, dependent: :destroy
  has_many :players, through: :teams_players

  serialize :available_jerseys
  serialize :taken_jerseys

  before_validation :update_available_jerseys

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

  private

  def take_jersey(given_jersey = nil)
    chosen_jersey = ""

    unless given_jersey.blank?
      chosen_jersey = given_jersey
    else
      chosen_jersey = available_jerseys.any? ? available_jerseys.sample : rand(20).to_s.rjust(2, "0")
    end

    available_jerseys.delete(chosen_jersey)
    add_to_pile(taken_jerseys, chosen_jersey)
    save

    chosen_jersey.to_s
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
end
