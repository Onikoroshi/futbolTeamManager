module TeamsHelper
  def available_jersey_select(team)
    options_for_select(team.available_jerseys.map{|jer| [jer, jer]})
  end
end
