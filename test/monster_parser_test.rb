require 'test_helper'

class MonsterParserTest < Test::Unit::TestCase

  def test_monster_id
    assert_equal "MONS_BAT", MonsterIdParser.new.parse("MONS_BAT").value
    assert_equal nil, MonsterIdParser.new.parse("foo bar")
  end

  def test_display_character
    assert_equal "a", DisplayCharacterParser.new.parse("\'a\'").value
    assert_equal "S", DisplayCharacterParser.new.parse("\'S\'").value
    assert_equal "4", DisplayCharacterParser.new.parse("\'4\'").value
    assert_equal nil, DisplayCharacterParser.new.parse("\'3d\'")
    assert_equal nil, DisplayCharacterParser.new.parse("d")
  end

  def test_display_colour
    assert_equal "LIGHTRED", DisplayColourParser.new.parse("LIGHTRED").value
    assert_equal nil, DisplayColourParser.new.parse("d")
  end

  def test_name
    assert_equal "soldier ant", NameParser.new.parse("\"soldier ant\"").value
    assert_equal nil, NameParser.new.parse("soldier ant")
    assert_equal nil, NameParser.new.parse("FOO")
  end

  def test_monster_flags
    assert_equal ["M_NO_SKELETON"], MonsterFlagsParser.new.parse("M_NO_SKELETON").value
    assert_equal ["M_SENSE_INVIS", "M_WARM_BLOOD", "M_BATTY"], MonsterFlagsParser.new.parse("M_SENSE_INVIS | M_WARM_BLOOD | M_BATTY").value
    assert_equal nil, MonsterFlagsParser.new.parse("soldier ant")
  end
end
