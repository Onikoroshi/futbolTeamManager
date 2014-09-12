require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "gives the first and last name as full_name" do
    player = players(:one)

    expected = player.first_name + " " + player.last_name
    assert_equals_with_expect(player.full_name, expected)
  end

  test "only gives the first name for full name if no last name" do
    player = players(:one)
    player.update_attributes(last_name: "")

    expected = player.first_name
    assert_equals_with_expect(player.full_name, expected)
  end

  test "only gives the last name for full name if no first name" do
    player = players(:one)
    player.update_attributes(first_name: "")

    expected = player.last_name
    assert_equals_with_expect(player.full_name, expected)
  end

  test "finds the correct teams_players object from a given team" do
    player = players(:one)

    assert player.player_team(nil) == nil, expect_got("nil", player.player_team(nil).to_s)

    team = teams(:one)
    team.add_player(player)
    player_team = TeamsPlayer.find_by(team_id: team.id, player_id: player.id)

    assert_equals_with_expect(player.player_team(team), player_team)
  end

  test "gets the correct jersey from a given team" do
    player = players(:one)
    team = teams(:one)
    jersey = "00"

    assert_equals_with_expect(player.team_jersey(team), "")

    team.add_player(player, jersey)
    assert_equals_with_expect(player.team_jersey(team), jersey)
  end

  test "destroys stat objects when destroyed" do
    player = players(:one)
    team = teams(:one)
    team.add_player(player)
    stat_type = stat_types(:one)
    value = 5
    stat = team.update_player_stat(stat_type, player, value)

    old_player_count = Player.count
    old_stat_count = Stat.count
    assert old_player_count > 0, expect_got("should be some players", old_player_count)
    assert old_stat_count > 0, expect_got("should be some stats", old_stat_count)

    player.destroy
    assert_equals_with_expect(Player.count, old_player_count-1)
    assert_equals_with_expect(Stat.count, old_stat_count-1)
  end
end
