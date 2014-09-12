# helps when displaying player stats
class EmptyTeam
  def empty_team?
    true
  end

  def name
    "Own Stats"
  end

  def method_missing(method_name, *args)
    nil
  end
end
