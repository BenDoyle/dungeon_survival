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

  def test_monster_mass
    assert_equal 60, NumberParser.new.parse("60").value
    assert_equal nil, NumberParser.new.parse("04")
    assert_equal nil, NumberParser.new.parse("soldier ant")
  end

  def test_exp_modifier_mass
    assert_equal 10, NumberParser.new.parse("10").value
    assert_equal 0, NumberParser.new.parse("0").value
    assert_equal nil, NumberParser.new.parse("04")
    assert_equal nil, NumberParser.new.parse("soldier ant")
  end

  def test_genus
    assert_equal "MONS_WORKER_ANT", ConstantParser.new.parse("MONS_WORKER_ANT").value
    assert_equal nil, ConstantParser.new.parse("foo bar")
  end

  def test_species
    assert_equal "MONS_QUEEN_ANT", ConstantParser.new.parse("MONS_QUEEN_ANT").value
    assert_equal nil, ConstantParser.new.parse("foo bar")
  end

  def test_holines
    assert_equal "MH_NATURAL", ConstantParser.new.parse("MH_NATURAL").value
    assert_equal nil, ConstantParser.new.parse("foo bar")
  end

  def test_resist_magic
    assert_equal -3, NumberParser.new.parse("-3").value
    assert_equal 0, NumberParser.new.parse("0").value
    assert_equal 10, NumberParser.new.parse("10").value
    assert_equal nil, NumberParser.new.parse("03")
  end

end
