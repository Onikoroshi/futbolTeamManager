types = [
  "Pass Initiated",
  "Pass Completed",
  "Pass Missed",
  "Pass Received",
  "Pass Fumbled",
  "Pass Intercepted",
  "Shot Taken",
  "Shot Missed",
  "Shot Blocked",
  "Shot Made",
  "Goal Allowed",
  "Goal Saved",
  "Ball Stolen",
  "Tackle Success"
]

types.each_with_index do |type, index|
  StatType.seed do |s|
    s.id = index+1
    s.name = type
  end
end

StatType.transaction do
  StatType.find_each do |st|
    st.save
  end
end
