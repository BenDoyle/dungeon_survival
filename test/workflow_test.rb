require 'test_helper'

class WorkflowTest < Test::Unit::TestCase

	def file_handles
		Dir['/Users/ben/Library/Application Support/Dungeon\ Crawl\ Stone\ Soup/morgue/*.txt']
	end

	def test_get_all_events
		input = [
			"Notes",
			"Turn   | Place   | Note",
			"--------------------------------------------------------------",
			"     0 | D:1     | Ben, the Deep Dwarf Necromancer, began the quest for the Orb.",
			"     0 | D:1     | Reached XP level 1. HP: 11/11 MP: 3/3",
			"   136 | D:1     | Reached skill 5 in Necromancy",
			"   197 | D:1     | Reached XP level 2. HP: 17/17 MP: 2/4",
			"  1410 | D:2     | Found a sparkling altar of Nemelex Xobeh.",
			"  1436 | D:2     | Reached XP level 3. HP: 18/24 MP: 5/5",
			"  1568 | D:3     | Noticed Sigmund",
			"  1876 | D:3     | Mangled by Sigmund",
			""
		]
		output = Workflow.new.get_all_events(input)

		assert_equal 8, output.size
		assert_equal [0, "D", 1, "Ben, the Deep Dwarf Necromancer, began the quest for the Orb."], output.first
		assert_equal [1876, "D", 3, "Mangled by Sigmund"], output.last
	end

	def test_events_begin
		w = Workflow.new
		assert_equal true, w.event_begin?("--------------------------------------------------------------")
		assert_equal false, w.event_begin?("------------------------------------X-------------------------")
	end	
  
  def test_parse_event
		w = Workflow.new
  	assert_equal nil, w.parse_event("junk")
  	assert_equal [0, "D", 1, "Crag, the Minotaur Warper, began the quest for the Orb."], w.parse_event("0 | D:1      | Crag, the Minotaur Warper, began the quest for the Orb.")
  	assert_equal [52941, "IceCv", 1, "Entered an ice cave"], w.parse_event("52941 | IceCv    | Entered an ice cave")
  	assert_equal [85973, "Depths", 1, "Identified the +1 pair of gloves of Deuhuiqaoc {Str+1 Dex+1} (Okawaru gifted it to you on level 1 of the Depths)"], w.parse_event("85973 | Depths:1 | Identified the +1 pair of gloves of Deuhuiqaoc {Str+1 Dex+1} (Okawaru gifted it to you on level 1 of the Depths)")
  	assert_equal [1, "D", 0, "Got out of the dungeon alive."], w.parse_event("1 | D:$      | Got out of the dungeon alive.")
  end

	def test_get_monsters
		input = [
			"junk",
			"Vanquished Creatures",
  		"  A giant gecko (D:1)",
			"38 creatures vanquished.",
			"",
			"Vanquished Creatures (others)",
			"  3 toadstools (D:1)",
			"4 creatures vanquished.",
			"other junk"
		]
		output = Workflow.new.get_monsters(input)

		assert_equal [[1, "giant gecko"]], output['yours']
		assert_equal [[3, 'toadstool']], output['others']
	end

	def test_indented?
  	w = Workflow.new
  	assert_equal true,  w.indented?("  x")
  	assert_equal false, w.indented?("An ooze (D:1)")
	end

  def test_parse_monster
  	w = Workflow.new
  	assert_equal nil, w.parse_monster("junk")
  	assert_equal [1, "Ijyb"], w.parse_monster("  Ijyb (D:2)")
  	assert_equal [1, "ooze"], w.parse_monster("  An ooze (D:1)")
  	assert_equal [1, "giant gecko"], w.parse_monster("  A giant gecko (D:1)")
  	assert_equal [4, "giant newt"], w.parse_monster("  4 giant newts")
  	assert_equal [2, "hobgoblin"], w.parse_monster("  2 hobgoblins (D:1)")
  end

	def test_get_monsters_vanquished
		w = Workflow.new
		assert_equal 38, w.get_monsters_vanquished("38 creatures vanquished.")
		assert_equal nil, w.get_monsters_vanquished("junk")
	end

	def test_get_monster_type
		w = Workflow.new
		assert_equal "yours", w.get_monster_type("Vanquished Creatures")
		assert_equal "others", w.get_monster_type("Vanquished Creatures (others)")
		assert_equal nil, w.get_monster_type("junk")
	end

	def test_get_durations
		w = Workflow.new
		assert_equal [639, 97], w.get_durations("Crag the Cudgeler (Minotaur Warper)                  Turns: 639, Time: 00:01:37")
		assert_equal [308781, 156787], w.get_durations("Zappy the Annihilator (Deep Elf Conjurer)      Turns: 308781, Time: 1, 19:33:07")
		assert_equal nil, w.get_durations("junk")
	end

	def test_get_start_date
		w = Workflow.new
		assert_equal '2011-04-23', w.get_start_date("             Began as a Deep Dwarf Necromancer on Apr 23, 2011.")
		assert_equal '2014-03-19', w.get_start_date("             Began as a Minotaur Warper on Mar 19, 2014.")
		assert_equal nil, w.get_start_date("junk")
	end

	def test_get_version
		w = Workflow.new
		assert_equal '0.7.1', w.get_version(" Dungeon Crawl Stone Soup version 0.7.1-1-g7ce9b19 character file.")
		assert_equal '0.13.1', w.get_version(" Dungeon Crawl Stone Soup version 0.13.1 (tiles) character file.")
		assert_equal nil, w.get_version("junk")
	end

	def test_read_file
		w = Workflow.new
		assert_equal %w[foo bar], w.read_file(File.join(File.dirname(__FILE__),'..','fixture','text.txt'))
	end

	def test_filter
		w = Workflow.new
		assert_equal true, w.log_filter("morgue-Zappy-20140217-205117.txt")
		assert_equal true, w.log_filter("morgue-ToughGuy-20121220-211639.txt")
		assert_equal false, w.log_filter("morgue-Zappy-20140217-205117.tt")
		assert_equal false, w.log_filter("-Zappy-20140217-205117.txt")
		assert_equal false, w.log_filter("morgue-20140217-205117.txt")
		assert_equal false, w.log_filter("Zappy-20140217-205117.txt")
		assert_equal false, w.log_filter("Zappy-20140217-205117.txt")
		assert_equal false, w.log_filter("morgue-Zappy-20140217.txt")
		assert_equal false, w.log_filter("morgue-Zappy.txt")
		assert_equal false, w.log_filter("Zappy.txt")
	end

end