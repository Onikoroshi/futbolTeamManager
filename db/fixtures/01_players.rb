20.times do |iteration|
  Player.seed do |p|
    index = iteration+1
    p.id = index

    p.first_name = Forgery(:name).first_name
    p.last_name = Forgery(:name).last_name
  end

  Player.transaction do
    Player.find_each do |p|
      p.save
    end
  end
end
