require 'test_helper'

class ExtractTest < Test::Unit::TestCase

  def test_parse_monster_unique
  	monster  = Extract.new.parse_monster("Ijyb (D:2)")
  	assert_equal monster[:type], "Ijyb"
  	assert_equal monster[:number], 1
  end

  def test_parse_monster_singe
  	monster  = Extract.new.parse_monster("An ooze (D:1)")
  	assert_equal monster[:type], "ooze"
  	assert_equal monster[:number], 1
  end

  def test_parse_monster_singe2
  	monster  = Extract.new.parse_monster("A giant gecko (D:2)")
  	assert_equal monster[:type], "giant gecko"
  	assert_equal monster[:number], 1
  end

  def test_parse_monster_multiple
  	monster  = Extract.new.parse_monster("4 giant newts")
  	assert_equal monster[:type], "giant newt"
  	assert_equal monster[:number], 4
  end

  def test_parse_monster_multiple2
  	monster  = Extract.new.parse_monster("2 hobgoblins (D:1)")
  	assert_equal monster[:type], "hobgoblin"
  	assert_equal monster[:number], 2
  end

end