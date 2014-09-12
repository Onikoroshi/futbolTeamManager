5.times do |iteration|
  Team.seed do |t|
    t.id = iteration+1
    t.name = Forgery(:name).first_name + "'s Team"
    t.available_jerseys = ("00".."20").to_a
    t.taken_jerseys = []
  end

  Team.transaction do
    Team.find_each do |t|
      t.save
    end
  end
end
