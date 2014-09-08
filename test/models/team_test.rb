require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test "find the proper teams_player object for a given player" do
    team = teams(:one)

    assert team.team_player(nil).class == EmptyTeamsPlayer.new.class, expect_got(EmptyTeamsPlayer.new.class, team.team_player(nil).to_s.class)

    player = players(:one)
    team.add_player(player)
    team_player = TeamsPlayer.find_by(team_id: team.id, player_id: player.id)

    assert_equals_with_expect(team.team_player(player), team_player)
  end

  test "properly adds a player to the team" do
    team = teams(:one)

    team.add_player(nil)
    assert_equals_with_expect(team.players.count, 0)

    player = players(:one)
    team.add_player(player)

    assert_equals_with_expect(team.players.count, 1)
    assert_equals_with_expect(team.player_jersey(player), "")

    player2 = players(:two)
    jersey = "00"
    team.add_player(player2, jersey)

    assert_equals_with_expect(team.players.count, 2)
    assert_equals_with_expect(team.player_jersey(player2), jersey)
  end

  test "gets proper jersey for a given player" do
    team = teams(:one)
    player = players(:one)
    jersey = "00"

    assert_equals_with_expect(team.player_jersey(player), "")

    team.add_player(player, jersey)
    assert_equals_with_expect(team.player_jersey(player), jersey)
  end

  test "assigns a given jersey to the given player" do
    team = teams(:one)
    player = players(:one)
    jersey = "00"

    assert !team.players.include?(player)

    team.assign_jersey(player, jersey) # nothing happens if the player isn't a part of the team

    assert_equals_with_expect(team.player_jersey(player), "")
    assert_equals_with_expect(player.team_jersey(team), "")
    assert_equals_with_expect(team.taken_jerseys, [])
    assert_equals_with_expect(team.available_jerseys, [])

    team.add_player(player)

    assert team.players.include?(player), expect_got(player.first_name, team.players.pluck(:first_name))
    assert_equals_with_expect(team.player_jersey(player), "")
    assert_equals_with_expect(player.team_jersey(team), "")
    assert_equals_with_expect(team.taken_jerseys, [])
    assert_equals_with_expect(team.available_jerseys, [])

    team.assign_jersey(player, jersey)

    assert_equals_with_expect(team.taken_jerseys, ["00"])
    assert_equals_with_expect(team.available_jerseys, [])
    assert_equals_with_expect(team.player_jersey(player), jersey)
    assert_equals_with_expect(player.team_jersey(team), jersey)
  end

  test "chooses a jersey to assign if none specified" do
    team = teams(:one)
    player = players(:one)

    assert !team.players.include?(player)

    team.assign_jersey(player) # nothing happens if the player isn't a part of the team

    assert_equals_with_expect(team.player_jersey(player), "")
    assert_equals_with_expect(player.team_jersey(team), "")
    assert_equals_with_expect(team.taken_jerseys, [])
    assert_equals_with_expect(team.available_jerseys, [])

    team.add_player(player)

    assert team.players.include?(player), expect_got(player.first_name, team.players.pluck(:first_name))
    assert_equals_with_expect(team.player_jersey(player), "")
    assert_equals_with_expect(player.team_jersey(team), "")
    assert_equals_with_expect(team.taken_jerseys, [])
    assert_equals_with_expect(team.available_jerseys, [])

    team.assign_jersey(player) # randomly chooses if none are available

    assert team.player_jersey(player) != "", expect_got("not ''", team.player_jersey(player))
    assert player.team_jersey(team) != "", expect_got("not ''", team.player_jersey(team))

    jersey = team.player_jersey(player)
    assert_equals_with_expect(team.taken_jerseys, [jersey])
    assert_equals_with_expect(team.available_jerseys, [])

    team.unassign_jersey(player)
    assert_equals_with_expect(team.taken_jerseys, [])
    assert_equals_with_expect(team.available_jerseys, [jersey])

    team.assign_jersey(player) # chooses from available
    assert_equals_with_expect(team.taken_jerseys, [jersey])
    assert_equals_with_expect(team.available_jerseys, [])
    assert_equals_with_expect(team.player_jersey(player), jersey)
    assert_equals_with_expect(player.team_jersey(team), jersey)
  end

  test "unassigns a player's current jersey" do
    team = teams(:one)
    player = players(:one)
    team.add_player(player)
    jersey = "00"
    team.assign_jersey(player, jersey)

    assert team.players.include?(player), expect_got(player.first_name, team.players.pluck(:first_name))
    assert_equals_with_expect(team.taken_jerseys, [jersey])
    assert_equals_with_expect(team.available_jerseys, [])
    assert_equals_with_expect(team.player_jersey(player), jersey)
    assert_equals_with_expect(player.team_jersey(team), jersey)

    team.unassign_jersey(player)
    assert_equals_with_expect(team.player_jersey(player), "")
    assert_equals_with_expect(player.team_jersey(team), "")
    assert_equals_with_expect(team.taken_jerseys, [])
    assert_equals_with_expect(team.available_jerseys, [jersey])
  end
end
