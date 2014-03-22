require 'test_helper'

class ExtractTest < Test::Unit::TestCase

  def test_parse_monster_unique
  	monster  = Extract.new.parse_monster("Ijyb (D:2)")
  	assert_equal "Ijyb", monster[:type]
  	assert_equal 1, monster[:number]
  end

  def test_parse_monster_singe
  	monster  = Extract.new.parse_monster("An ooze (D:1)")
  	assert_equal "ooze", monster[:type]
  	assert_equal 1, monster[:number]
  end

  def test_parse_monster_singe2
  	monster  = Extract.new.parse_monster("A giant gecko (D:2)")
  	assert_equal "giant gecko", monster[:type]
  	assert_equal 1, monster[:number]
  end

  def test_parse_monster_multiple
  	monster  = Extract.new.parse_monster("4 giant newts")
  	assert_equal "giant newt", monster[:type]
  	assert_equal 4, monster[:number]
  end

  def test_parse_monster_multiple2
  	monster  = Extract.new.parse_monster("2 hobgoblins (D:1)")
  	assert_equal "hobgoblin", monster[:type]
  	assert_equal 2, monster[:number]
  end

  def test_parse_events
  	event  = Extract.new.parse_events("0 | D:1      | Crag, the Minotaur Warper, began the quest for the Orb.")
  	assert_equal 0, event[:turn]
  	assert_equal "D", event[:branch]
  	assert_equal 1, event[:level]
  	assert_equal "Crag, the Minotaur Warper, began the quest for the Orb.", event[:message]
  end

  def test_parse_events2
  	event  = Extract.new.parse_events("52941 | IceCv    | Entered an ice cave")
  	assert_equal 52941, event[:turn]
  	assert_equal "IceCv", event[:branch]
  	assert_equal 1, event[:level]
  	assert_equal "Entered an ice cave", event[:message]
  end

  def test_parse_events3
  	event  = Extract.new.parse_events("85973 | Depths:1 | Identified the +1 pair of gloves of Deuhuiqaoc {Str+1 Dex+1} (Okawaru gifted it to you on level 1 of the Depths)")
  	assert_equal 85973, event[:turn]
  	assert_equal "Depths", event[:branch]
  	assert_equal 1, event[:level]
  	assert_equal "Identified the +1 pair of gloves of Deuhuiqaoc {Str+1 Dex+1} (Okawaru gifted it to you on level 1 of the Depths)", event[:message]
  end

  def test_parse_stats_version
  	stat = Extract.new.parse_stats('Dungeon Crawl Stone Soup version 0.13.1 (tiles) character file.')
  	assert_equal '0.13.1', stat[:version]
  end

  def test_parse_stats_began
  	stat = Extract.new.parse_stats('Began as a Minotaur Warper on Mar 19, 2014.')
  	assert_equal 'Minotaur', stat[:species]
  	assert_equal 'Warper',   stat[:background]
  	assert_equal 'Mar 19, 2014', stat[:start_date]
  end

  def test_parse_stats_duration
  	stat = Extract.new.parse_stats('The game lasted 00:01:37 (639 turns).')
  	assert_equal 97,  stat[:game_duration_seconds]
  	assert_equal 639, stat[:game_duration_turns]
  end

	def test_all_parse
 		morgue_file = File.join(File.dirname(__FILE__),'..','data','morgue-Crag-20140319-212609.txt')
    extractor = Extract.new

    extractor.parse_morgue_file(morgue_file)

    puts
    puts extractor.stats.inspect
    puts
    puts extractor.monsters.inspect
    puts
    puts extractor.events.inspect

    assert False
  end

end