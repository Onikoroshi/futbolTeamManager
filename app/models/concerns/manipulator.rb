class Manipulator
  def self.combine(*words)
    self.squash(words).gsub(/\s/, "")
  end

  def self.underscore(*words)
    self.squash(words).gsub(/\s/, "_")
  end

  private

  def self.squash(*words)
    words.join(" ").squish.downcase
  end
end
