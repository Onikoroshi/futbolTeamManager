20.times do |iteration|
  Player.seed do |p|
    index = iteration+1
    p.id = index

    f_name = Forgery(:name).first_name
    l_name = Forgery(:name).last_name

    p.first_name = f_name
    p.last_name = l_name
    p.combined_name = f_name.to_s.downcase + l_name.to_s.downcase
  end
end
