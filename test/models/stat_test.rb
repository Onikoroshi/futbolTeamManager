require 'test_helper'

class StatTest < ActiveSupport::TestCase
  test "requires stat type" do
    team = teams(:one)
    player = players(:one)
    stat = stats(:one)
    stat.update_attributes(team_id: team.id, player_id: player.id)

    assert !stat.valid?, expect_got("invalid model", "valid")
    assert stat.errors.keys.include?(:stat_type), expect_got("stat type in errors", stat.errors.keys)
  end

  test "requires player" do
    team = teams(:one)
    stat_type = stat_types(:one)
    stat = stats(:one)
    stat.update_attributes(team_id: team.id, stat_type_id: stat_type.id)

    assert !stat.valid?, expect_got("invalid model", "valid")
    assert stat.errors.keys.include?(:player), expect_got("player in errors", stat.errors.keys)
  end

  test "doesn't require team" do
    stat_type = stat_types(:one)
    player = players(:one)
    stat = stats(:one)
    stat.update_attributes(player_id: player.id, stat_type_id: stat_type.id)

    assert stat.valid?, expect_got("valid model", "invalid")
  end

  test "correctly determines if can be decremented" do
    stat = stats(:one)
    value = 0

    stat.update_attributes(value: value)
    assert !stat.can_decrement?, expect_got("can't decrement because value is " + value.to_s, "value is " + stat.value.to_s)

    value = 0.9
    stat.update_attributes(value: value)
    assert !stat.can_decrement?, expect_got("can't decrement because value is " + value.to_s, "value is " + stat.value.to_s)

    value = 1
    stat.update_attributes(value: value)
    assert stat.can_decrement?, expect_got("can decrement because value is " + value.to_s, "value is " + stat.value.to_s)

    value = 1.1
    stat.update_attributes(value: value)
    assert stat.can_decrement?, expect_got("can decrement because value is " + value.to_s, "value is " + stat.value.to_s)
  end

  test "correctly decrements" do
    team = teams(:one)
    player = players(:one)
    stat_type = stat_types(:one)
    stat = stats(:one)
    value = 5
    stat.update_attributes(team_id: team.id, player_id: player.id, stat_type_id: stat_type.id, value: value)

    assert stat.valid?, "should be valid, but wasn't!"

    assert stat.decrement
    assert_equals_with_expect(stat.value, (value-1).to_f)

    value = 0.9
    stat.update_attributes(value: value)
    assert !stat.decrement, "decrement should fail at " + value.to_s
    assert_equals_with_expect(stat.value, value.to_f)
  end

  test "correctly increments" do
    team = teams(:one)
    player = players(:one)
    stat_type = stat_types(:one)
    stat = stats(:one)
    value = 5
    stat.update_attributes(team_id: team.id, player_id: player.id, stat_type_id: stat_type.id, value: value)

    assert stat.valid?, "should be valid, but wasn't!"

    assert stat.increment, "increment should succeed!"
    assert_equals_with_expect(stat.value, (value+1).to_f)
  end
end
