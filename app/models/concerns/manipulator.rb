class Manipulator
  def self.combine(*words)
    words.join(" ").squish.downcase.gsub(/\s/, "")
  end
end
