class Stat < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  belongs_to :stat_type

  validates :stat_type, presence: true
  validate :player_or_team_present

  def can_decrement?
    value.present? && value >= 1
  end

  private

  def player_or_team_present
    unless player.present? || team.present?
      errors.add(:team_player, "Must belong to either a player, a team, or both")
    end
  end
end

class EmptyStat
  def can_decrement?
    false
  end

  def value
    0
  end

  def method_missing(method_name, *args)
    nil
  end
end
