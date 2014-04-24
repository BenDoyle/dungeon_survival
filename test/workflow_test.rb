require 'test_helper'

class WorkflowTest < Test::Unit::TestCase

	def file_handles
		Dir['/Users/ben/Library/Application Support/Dungeon\ Crawl\ Stone\ Soup/morgue/*.txt']
	end

	def test_parse_basic
		w = Workflow.new

		message = "junk"
  	assert_equal({:type => :unknown, message: message}, w.parse_message(message))

		message  = "Ben, the Deep Dwarf Necromancer, began the quest for the Orb."
  	expected = {
  		type: :start,
  		message: message,
  		name: "Ben",
  		species_background: "Deep Dwarf Necromancer"
  	}
  	parsed   = w.parse_message(message)
  	assert_equal expected, parsed
  end

	def test_parse_died
		message  = "Annihilated by an ogre"
  	expected = {
  		type: :died,
  		message: message,
  		cause: "an ogre"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Killed from afar by an orc wizard"
  	expected = {
  		type: :died,
  		message: message,
  		cause: "an orc wizard"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Succumbed to a worker ant's poison"
  	expected = {
  		type: :died,
  		message: message,
  		cause: "a worker ant"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Killed themself with bad targetting"
  	expected = {
  		type: :died,
  		message: message,
  		cause: "self"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_parse_noticed
		message  = "Noticed a spriggan baker"
  	expected = {
  		type: :noticed_monster,
  		message: message,
  		monster: "spriggan baker"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_parse_killed
		message  = "Defeated Purgy"
  	expected = {
  		type: :killed_monster,
  		message: message,
  		monster: "Purgy"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Killed Zappy's ghost"
  	expected = {
  		type: :killed_monster,
  		message: message,
  		monster: "Zappy's ghost"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_parse_gained_ally
		message  = "Gained Boruk as an ally"
  	expected = {
  		type: :gained_ally,
  		message: message,
  		monster: "Boruk"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_parse_lost_ally
		message  = "Your ally Boghold died"
  	expected = {
  		type: :lost_ally,
  		message: message,
  		monster: "Boghold"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_parse_paralysed
		message  = "Paralysed by a great orb of eyes for 5 turns"
  	expected = {
  		type: :paralysed,
  		message: message,
  		monster: "a great orb of eyes"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_parse_shot
		message  = "Shot with a runed arrow by a centaur warrior"
  	expected = {
  		type: :shot,
  		message: message,
  		with: "a runed arrow",
  		monster: "a centaur warrior"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Splashed by a jelly's acid"
  	expected = {
  		type: :shot,
  		message: message,
  		with: 'acid',
  		monster: "a jelly"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_parse_xp
		message  = "Reached XP level 6. HP: 38/38 MP: 5/5"
  	expected = {
  		type: :xp,
  		message: message,
  		level: "6",
  		skill: "level"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Reached skill level 5 in Armour"
  	expected = {
  		type: :xp,
  		message: message,
  		level: "5",
  		skill: "Armour"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_learned_spell
		message  = "Learned a level 2 spell: Blink"
  	expected = {
  		type: :learned_spell,
  		message: message,
  		spell: "Blink"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_gained_mutation
		message  = "Gained mutation: Your wings are large and strong. [gargoyle growth]"
  	expected = {
  		type: :gained_mutation,
  		message: message,
  		mutation: "Your wings are large and strong"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_lost_mutation
		message  = "Lost mutation: Your mind is acute (Int +1)."
  	expected = {
  		type: :lost_mutation,
  		message: message,
  		mutation: "Your mind is acute (Int +1)"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_found_altar
		message  = "Found a viscous altar of Jiyva."
  	expected = {
  		type: :found_altar,
  		message: message,
  		god: "Jiyva"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_joined_religion
		message  = "Became a worshipper of Makhleb the Destroyer"
  	expected = {
  		type: :joined_religion,
  		message: message,
  		god: "Makhleb"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_fell_from_grace
		message  = "Fell from the grace of Okawaru"
  	expected = {
  		type: :fell_from_grace,
  		message: message,
  		god: "Okawaru"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_god_power
		message  = "Acquired Okawaru's first power"
  	expected = {
  		type: :god_power,
  		message: message,
  		god: "Okawaru",
  		number: "first"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_god_protection
		message  = "Beogh protects you from harm!"
  	expected = {
  		type: :god_protection,
  		message: message,
  		god: "Beogh"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_vehumet_spell
		message  = "Offered knowledge of Shock by Vehumet."
  	expected = {
  		type: :vehumet_spell,
  		message: message,
  		spell: "Shock"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_god_gift
		message  = "Received a gift from Okawaru"
  	expected = {
  		type: :god_gift,
  		message: message,
  		god: "Okawaru"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_penance
		message  = "Was placed under penance by Beogh"
  	expected = {
  		type: :penance,
  		message: message,
  		god: "Beogh"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_forgiven
		message  = "Was forgiven by Okawaru"
  	expected = {
  		type: :forgiven,
  		message: message,
  		god: "Okawaru"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_entered
		message  = "Entered Level 10 of the Dungeon"
  	expected = {
  		type: :entered,
  		message: message,
  		level: "10",
  		branch: "the Dungeon"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "You paid a toll of 4770 gold to enter a ziggurat."
  	expected = {
  		type: :entered,
  		message: message,
  		level: "1",
  		branch: "ziggurat"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_found_entrance
		message  = "Found a staircase to the Ecumenical Temple."
  	expected = {
  		type: :found_entrance,
  		message: message,
  		branch: "Ecumenical Temple"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Found a glowing drain."
  	expected = {
  		type: :found_entrance,
  		message: message,
  		branch: "sewer"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_found_shop
		message  = "Found Xeah's Antique Armour Emporium."
  	expected = {
  		type: :found_shop,
  		message: message,
  		shop: "Xeah's Antique Armour Emporium"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_shaft
		message  = "You fall through a shaft for 2 floors!"
  	expected = {
  		type: :shaft,
  		message: message,
  		floors: "2"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "You fall through a shaft!"
  	expected = {
  		type: :shaft,
  		message: message,
  		floors: "1"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end

	def test_got_item
		message  = "Got a twisted helmet"
  	expected = {
  		type: :got_item,
  		message: message,
  		item: "a twisted helmet"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end
	
	def test_bought_item
		message  = "Bought a shiny buckler for 75 gold pieces"
  	expected = {
  		type: :bought_item,
  		message: message,
  		item: "a shiny buckler",
  		gold: "75"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end
	
	def test_identified_item
		message  = "Identified the cursed +1 helmet of Daicucs {+Blink rF+ Dex-1 SInv} (You found it on level 10 of the Dungeon)"
  	expected = {
  		type: :identified_item,
  		message: message,
  		item: "the cursed +1 helmet of Daicucs {+Blink rF+ Dex-1 SInv}"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end
	
	def test_banished_monster
		message  = "Banished Grinder"
  	expected = {
  		type: :banished_monster,
  		message: message,
  		monster: "Grinder"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end
	
	def test_entered
		message  = "Entered an ice cave"
  	expected = {
  		type: :entered,
  		message: message,
  		branch: "an ice cave",
  		level: "1"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Entered an ice cave"
  	expected = {
  		type: :entered,
  		message: message,
  		branch: "an ice cave",
  		level: "1"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Cast into the Abyss (a Zot trap)"
  	expected = {
  		type: :entered,
  		message: message,
  		branch: "abyss",
  		level: "1"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Voluntarily entered the Abyss."
  	expected = {
  		type: :entered,
  		message: message,
  		branch: "abyss",
  		level: "1"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
	end
	
	def test_exited
		message  = "Escaped Pandemonium"
  	expected = {
  		type: :exited,
  		message: message,
  		branch: "pandemonium"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "Escaped the Abyss"
  	expected = {
  		type: :exited,
  		message: message,
  		branch: "abyss"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed

		message  = "You pass through the gate."
  	expected = {
  		type: :exited,
  		message: message,
  		branch: "abyss"
  	}
  	parsed = Workflow.new.parse_message(message)
  	assert_equal expected, parsed
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

		assert_equal [[1, "giant gecko"]], output[:yours]
		assert_equal [[3, 'toadstool']], output[:others]
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
		assert_equal({mode: 'Dungeon Crawl Stone Soup', version: '0.7.1'},  w.get_mode_and_version(" Dungeon Crawl Stone Soup version 0.7.1-1-g7ce9b19 character file."))
		assert_equal({mode: 'Dungeon Crawl Stone Soup', version: '0.13.1'}, w.get_mode_and_version(" Dungeon Crawl Stone Soup version 0.13.1 (tiles) character file."))
		assert_equal({mode: 'Dungeon Sprint DCSS',      version: '0.14'},   w.get_mode_and_version(" Dungeon Sprint DCSS version 0.14-a0-1128-gf332958 (tiles) character file."))
		assert_equal nil, w.get_mode_and_version("junk")
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