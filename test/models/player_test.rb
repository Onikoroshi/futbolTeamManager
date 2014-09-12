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
end
