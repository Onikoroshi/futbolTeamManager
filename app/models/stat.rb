class Stat < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  belongs_to :stat_type

  # It's ok to have orphan player stats, because a player can have stats
  # independant of a team. However, a team cannot have stats by itself,
  # so at least the player id must be present
  validates :stat_type, :player, presence: true

  def can_decrement?
    value.present? && value >= 1.0
  end

  def decrement
    if can_decrement?
      self.value -= 1
      save
    else
      false
    end
  end

  def increment
    self.value += 1
    save
  end

  def add_to(amount)
    self.value += amount.to_f
    save
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
