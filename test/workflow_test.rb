require 'test_helper'

class WorkflowTest < Test::Unit::TestCase

	def file_handles
		Dir['/Users/ben/Library/Application Support/Dungeon\ Crawl\ Stone\ Soup/morgue/*.txt']
	end

  def test_parse_monster_unique
  	w = Workflow.new
  	monster  = w.parse_monster("Ijyb (D:2)")
  	assert_equal "Ijyb", monster[:type]
  	assert_equal 1, monster[:number]
  end

  def test_parse_monster_singe
  	w = Workflow.new
  	monster  = w.parse_monster("An ooze (D:1)")
  	assert_equal "ooze", monster[:type]
  	assert_equal 1, monster[:number]
  end

  def test_parse_monster_singe2
  	w = Workflow.new
  	monster  = w.parse_monster("A giant gecko (D:2)")
  	assert_equal "giant gecko", monster[:type]
  	assert_equal 1, monster[:number]
  end

  def test_parse_monster_multiple
  	w = Workflow.new
  	monster  = w.parse_monster("4 giant newts")
  	assert_equal "giant newt", monster[:type]
  	assert_equal 4, monster[:number]
  end

  def test_parse_monster_multiple2
  	w = Workflow.new
  	monster  = w.parse_monster("2 hobgoblins (D:1)")
  	assert_equal "hobgoblin", monster[:type]
  	assert_equal 2, monster[:number]
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