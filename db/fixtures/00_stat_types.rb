types = [
  "pass initiated",
  "pass completed",
  "pass missed",
  "pass received",
  "shot taken",
  "shot missed",
  "shot blocked",
  "shot saved",
  "goal made",
  "goal allowed",
  "ball stolen",
  "stolen from"
]

types.each_with_index do |type, index|
  StatType.seed do |s|
    s.id = index+1
    s.name = type
  end
end
