class TeamsPlayer < ActiveRecord::Base
  belongs_to :team
  belongs_to :player
end

class EmptyTeamsPlayer
  def jersey
    ""
  end

  def method_missing(method_name, *args)
    nil
  end
end
