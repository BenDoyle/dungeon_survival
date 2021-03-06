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
    assert_equal "@", QuotedCharacterParser.new.parse("\'@\'").value
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
    assert_equal ["M_SENSE_INVIS", "M_WARM_BLOOD", "M_BATTY"], ConstantListParser.new.parse("M_SENSE_INVIS  | M_WARM_BLOOD | M_BATTY").value
    assert_equal nil, ConstantListParser.new.parse("soldier ant")
  end

  def test_multi_line_monster_flags
    field = <<-STR
      M_SENSE_INVIS | M_WARM_BLOOD 
      | M_BATTY
    STR
    assert_equal ["M_SENSE_INVIS", "M_WARM_BLOOD", "M_BATTY"], ConstantListParser.new.parse(field.strip).value
  end

  def test_monster_resistance_flags
    assert_equal ["MR_NO_FLAGS"], ConstantListParser.new.parse("MR_NO_FLAGS").value
    assert_equal ["MR_RES_POISON", "MR_RES_HELLFIRE", "MR_VUL_WATER"], ConstantListParser.new.parse("MR_RES_POISON | MR_RES_HELLFIRE | MR_VUL_WATER").value
    assert_equal nil, ConstantListParser.new.parse("soldier ant")
  end

  def test_monster_resistance_flags_with_mrdd
    field = <<-STR
      MR_RES_POISON 
      | MR_VUL_FIRE | mrd(MR_RES_COLD, 3) | mrd(MR_RES_ELEC, 2),
    STR
    assert_equal ["MR_RES_POISON", "MR_VUL_FIRE", "MR_RES_COLD_3", "MR_RES_ELEC_2"], ConstantListParser.new.parse(field.strip).value
    assert_equal ["MR_RES_POISON_3", "MR_RES_FIRE_2", "MR_RES_COLD_2", "MR_RES_ELEC_2"], ConstantListParser.new.parse("mrd(MR_RES_POISON, 3) | mrd(MR_RES_FIRE | MR_RES_COLD | MR_RES_ELEC, 2)").value
  end

  def test_monster_resistance_flags_with_mrdd
    assert_equal ["MR_RES_COLD_3"], ConstantListParser.new.parse("mrd(MR_RES_COLD, 3)").value
    assert_equal ["MR_RES_COLD"], ConstantListParser.new.parse("MR_RES_COLD").value
    assert_equal ["MR_RES_POISON_3", "MR_RES_FIRE_2", "MR_RES_COLD_2", "MR_RES_ELEC_2"], ConstantListParser.new.parse("mrd(MR_RES_POISON, 3) | mrd(MR_RES_FIRE | MR_RES_COLD | MR_RES_ELEC, 2)").value
    assert_equal ["MR_RES_ELEC_2", "MR_RES_POISON", "MR_RES_FIRE"], ConstantListParser.new.parse("mrd(MR_RES_ELEC, 2) | MR_RES_POISON | MR_RES_FIRE").value
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
    assert_equal -3, NumberOrConstantParser.new.parse("-3").value
    assert_equal 0, NumberOrConstantParser.new.parse("0").value
    assert_equal 10, NumberOrConstantParser.new.parse("10").value
    assert_equal nil, NumberOrConstantParser.new.parse("03")
    assert_equal "MAG_IMMUNE", NumberOrConstantParser.new.parse("MAG_IMMUNE").value
  end

  def test_attacks
    assert_equal [['AT_STING', 'AF_POISON_STRONG', 20], 'AT_NO_ATK', 'AT_NO_ATK', 'AT_NO_ATK'], AttacksParser.new.parse("{ {AT_STING, AF_POISON_STRONG, 20}, AT_NO_ATK, AT_NO_ATK, AT_NO_ATK }").value
    field = <<-STR
    { {AT_HIT, AF_PAIN, 25}, {AT_HIT, AF_DRAIN_XP, 15},
      {AT_HIT, AF_DRAIN_XP, 15}, AT_NO_ATK }
    STR
    assert_equal [['AT_HIT', 'AF_PAIN', 25], ['AT_HIT', 'AF_DRAIN_XP', 15], ['AT_HIT', 'AF_DRAIN_XP', 15], 'AT_NO_ATK'], AttacksParser.new.parse(field.strip).value
    assert_equal nil, AttacksParser.new.parse("foo")
  end

  def test_hit_points
    assert_equal [18, 3, 5, 0], HitPointsParser.new.parse("{ 18, 3, 5, 0 }").value
    assert_equal nil, HitPointsParser.new.parse("{ 018, 3, 5, 0 }")
    assert_equal nil, HitPointsParser.new.parse("foo")
  end

  def test_monster
    monster = <<-STR
      {
          MONS_MNOLEG, '&', LIGHTGREEN, "Mnoleg",
          M_UNIQUE | M_FIGHTER | M_SEE_INVIS | M_SPELLCASTER | M_SPEAKS,
          mrd(MR_RES_ELEC, 2) | MR_RES_POISON | MR_RES_FIRE,
          0, 15, MONS_PANDEMONIUM_LORD, MONS_PANDEMONIUM_LORD, MH_DEMONIC, MAG_IMMUNE,
          { {AT_HIT, AF_MUTATE, 35}, {AT_HIT, AF_BLINK, 23}, AT_NO_ATK, AT_NO_ATK },
          { 17, 0, 0, 350 },
          10, 25, MST_MNOLEG, CE_NOCORPSE, Z_NOZOMBIE, S_BUZZ,
          I_HIGH, HT_LAND, FL_NONE, 13, DEFAULT_ENERGY,
          MONUSE_OPEN_DOORS, MONEAT_NOTHING, SIZE_LARGE
      }    
    STR
    assert_equal monster.strip, MonsterParser.new.parse(monster.strip).text_value
    monster = <<-STR
      {
          MONS_MNOLEG, '&', LIGHTGREEN, "Mnoleg",
          M_UNIQUE | M_FIGHTER | M_SEE_INVIS | M_SPELLCASTER | M_SPEAKS,
          mrd(MR_RES_ELEC, 2) | MR_RES_POISON | MR_RES_FIRE,
          0, 15, MONS_PANDEMONIUM_LORD, MONS_PANDEMONIUM_LORD, MH_DEMONIC, -2,
          { {AT_HIT, AF_MUTATE, 35}, {AT_HIT, AF_BLINK, 23}, AT_NO_ATK, AT_NO_ATK },
          { 17, 0, 0, 350 },
          10, 25, MST_MNOLEG, CE_NOCORPSE, Z_NOZOMBIE, S_BUZZ,
          I_HIGH, HT_LAND, FL_NONE, 13, DEFAULT_ENERGY,
          MONUSE_OPEN_DOORS, MONEAT_NOTHING, SIZE_LARGE
      }    
    STR
    assert_equal monster.strip, MonsterParser.new.parse(monster.strip).text_value
    monster = <<-STR
      { // comment is ignored
          MONS_MNOLEG, '&', LIGHTGREEN, "Mnoleg",
          M_UNIQUE | M_FIGHTER | M_SEE_INVIS | M_SPELLCASTER | M_SPEAKS,
          mrd(MR_RES_ELEC, 2) | MR_RES_POISON | MR_RES_FIRE,
          0, 15, MONS_PANDEMONIUM_LORD, MONS_PANDEMONIUM_LORD, MH_DEMONIC, -2,
          { {AT_HIT, AF_MUTATE, 35}, {AT_HIT, AF_BLINK, 23}, AT_NO_ATK, AT_NO_ATK },
          { 17, 0, /* the other sort of comment... */ 0, 350 }, //also this comment 
          10, 25, MST_MNOLEG, CE_NOCORPSE, Z_NOZOMBIE, S_BUZZ,
          I_HIGH, HT_LAND, FL_NONE, 13, DEFAULT_ENERGY,
          MONUSE_OPEN_DOORS, MONEAT_NOTHING, SIZE_LARGE // and this comment too
      }    
    STR
    attributes = {
      id: 'MONS_MNOLEG',
      symbol: '&',
      colour: 'LIGHTGREEN',
      name: 'Mnoleg',
      flags: %w[M_UNIQUE M_FIGHTER M_SEE_INVIS M_SPELLCASTER M_SPEAKS],
      resistances: %w[MR_RES_ELEC_2 MR_RES_POISON MR_RES_FIRE],
      mass: 0,
      experience: 15,
      genus: 'MONS_PANDEMONIUM_LORD',
      species: 'MONS_PANDEMONIUM_LORD',
      holiness: 'MH_DEMONIC',
      resist_magic: -2,
      atacks: [["AT_HIT", "AF_MUTATE", 35], ["AT_HIT", "AF_BLINK", 23], "AT_NO_ATK", "AT_NO_ATK"],
      hit_points: [17, 0, 0, 350],
      ac: 10,
      evasion: 25,
      spell_set: 'MST_MNOLEG',
      corpse_class: 'CE_NOCORPSE',
      zombie_size: 'Z_NOZOMBIE',
      shouts_set: 'S_BUZZ',
      inteligence: 'I_HIGH',
      habitat: 'HT_LAND',
      flight_class: 'FL_NONE',
      speed: 13,
      energy_usage: 'DEFAULT_ENERGY',
      uses: 'MONUSE_OPEN_DOORS',
      eats: 'MONEAT_NOTHING',
      body_size: 'SIZE_LARGE',
    }
    assert_equal attributes, MonsterParser.new.parse(monster.strip).value
  end

end
