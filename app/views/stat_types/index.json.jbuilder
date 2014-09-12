json.array!(@stat_types) do |stat_type|
  json.extract! stat_type, :id, :name, :identifier
  json.url stat_type_url(stat_type, format: :json)
end
