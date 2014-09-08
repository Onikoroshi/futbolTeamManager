class Team < ActiveRecord::Base
  has_many :stats
  has_many :teams_players
  has_many :players, through: :teams_players

  serialize :available_jerseys
  serialize :taken_jerseys

  def team_player(player)
    player.present? ? teams_players.find_by(player_id: player.id) : nil
  end

  def add_player(player, jersey = nil)
    teams_players << TeamsPlayer.create(team_id: self.id, player_id: player.id, jersey: (jersey.blank? ? "" : take_jersey(jersey))) if player.present?
  end

  def player_jersey(player)
    found_player = team_player(player)
    found_player.present? ? found_player.jersey : ""
  end

  def assign_jersey(player, jersey = nil)
    found_player = team_player(player)
    found_player.update_attributes(jersey: take_jersey(jersey)) if found_player.present?
  end

  def unassign_jersey(player)
    found_player = team_player(player)
    if found_player.present?
      return_jersey(found_player.jersey)
      found_player.update_attributes(jersey: "")
    end
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

  def return_jersey(jersey)
    if jersey.present? && taken_jerseys.include?(jersey)
      taken_jerseys.delete(jersey)
      add_to_pile(available_jerseys, jersey)
      save
    end
  end

  def add_to_pile(pile, jersey)
    pile << jersey
    pile.reject!(&:empty?)
    pile.uniq!
  end
end
