require 'test_helper'

class MonsterParserTest < Test::Unit::TestCase

  def test_monster_id
    assert_equal "MONS_BAT", ConstantParser.new.parse("MONS_BAT").value
    assert_equal nil, ConstantParser.new.parse("foo bar")
  end

  def test_display_character
    assert_equal "a", QuotedCharacterParser.new.parse("\'a\'").value
    assert_equal "S", QuotedCharacterParser.new.parse("\'S\'").value
    assert_equal "4", QuotedCharacterParser.new.parse("\'4\'").value
    assert_equal nil, QuotedCharacterParser.new.parse("\'3d\'")
    assert_equal nil, QuotedCharacterParser.new.parse("d")
  end

  def test_display_colour
    assert_equal "LIGHTRED", ConstantParser.new.parse("LIGHTRED").value
    assert_equal nil, ConstantParser.new.parse("d")
  end

  def test_name
    assert_equal "soldier ant", QuotedStringParser.new.parse("\"soldier ant\"").value
    assert_equal nil, QuotedStringParser.new.parse("soldier ant")
    assert_equal nil, QuotedStringParser.new.parse("FOO")
  end

  def test_monster_flags
    assert_equal ["M_NO_SKELETON"], ConstantListParser.new.parse("M_NO_SKELETON").value
    assert_equal ["M_SENSE_INVIS", "M_WARM_BLOOD", "M_BATTY"], ConstantListParser.new.parse("M_SENSE_INVIS | M_WARM_BLOOD | M_BATTY").value
    assert_equal nil, ConstantListParser.new.parse("soldier ant")
  end

  def test_monster_resistance_flags
    assert_equal ["MR_NO_FLAGS"], ConstantListParser.new.parse("MR_NO_FLAGS").value
    assert_equal ["MR_RES_POISON", "MR_RES_HELLFIRE", "MR_VUL_WATER"], ConstantListParser.new.parse("MR_RES_POISON | MR_RES_HELLFIRE | MR_VUL_WATER").value
    assert_equal nil, ConstantListParser.new.parse("soldier ant")
  end

end
