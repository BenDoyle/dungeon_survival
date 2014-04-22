require File.join(File.dirname(__FILE__),'..','lib','message_parser.rb')

class Workflow

	def log_filter(filename)
		filename.scan(/morgue-(\w+)-(\d{8}-\d{6})\.txt/).any?
	end

	def read_file(filename)
		File.readlines(filename).map{|line| line.gsub(/\n/, "")}
	end

	def get_version(line)
    m = line.scan(/Dungeon Crawl Stone Soup version ([\.\d]+)/) 
    m && m.first && m.first.first
	end

	def get_start_date(line)
		m = line.scan(/Began as a [ \w]+ on ([ \w,]+)./)
		m && m.first && m.first.first && Date.parse(m.first.first).to_s
	end

	def get_durations(line)
		duration_re = /Turns\: (\d+)\, Time: (\d+)?\,?\s?(\d{2})\:(\d{2})\:(\d{2})/
    if line =~ duration_re
      values = line.scan(duration_re).first
      return [
      	values[0].to_i,
      	(values[1] || 0).to_i*3600*24 + values[2].to_i*3600 + values[3].to_i*60 + values[4].to_i,
      ]
    end
	end

	def get_monster_type(line)
		m = line.scan(/^(Vanquished Creatures)(\s+\(([ \w]+)\))?/)
		if m && m.first 
			return m.first[2] || 'yours'
		end
	end

	def get_monsters_vanquished(line)
		m = line.scan(/^(\d+) creatures vanquished./)
		m && m.first && m.first.first && m.first.first.to_i 
	end

  def parse_monster(line)
  	m = line.scan(/^  (\d+|An?\s+)?([ a-zA-Z]+)/)
    if m && m.first
    	values = m.first
	    number = values[0].to_i
	    number = 1 if number.zero?
	    type   = values[1].strip
	    type   = type[0..-2] if number > 1
	    [number, type]
	  end
  end

  def indented?(line)
		!line.scan(/^(\s{2})/).empty?
  end

	def get_monsters(lines)
		out = {}
		key = nil
		lines.each do |line|
			key = nil if key && get_monsters_vanquished(line)
			key = get_monster_type(line) unless key
			if key && indented?(line)
				out[key.to_sym] ||= []
				out[key.to_sym]  <<  parse_monster(line)
			end
		end
		out
	end

	def parse_event(line)
  	m = line.scan(/(\d+)\s+\|\s+(\w+):?(\d{1,2}|\$)?\s+\|\s+(.+)/)
    if m && m.first
    	turn, branch, level, message = m.first
	    level ||= 1
	    level ==  '$' ? 0 : level
	    level = level.to_i
	    [ 
	    	turn.to_i,
	      branch,
	      level,
	      message
	    ]
	  end
	end

	def event_begin?(line)
		line == "--------------------------------------------------------------"
	end

	def get_all_events(lines)
		events = []
		ready = false
		lines.each do |line|
			if ready
				event = parse_event(line) 
				events << event if event
			end
			ready = true if event_begin?(line)
		end
		events
	end

	def parse_message(message)
    message_parsers = [
    	MessageParser.new(:start, /^(?<name>\w+), the (?<species_background>[ \w]+), began the quest for the Orb./),
	    MessageParser.new(:upgrade, /^Upgraded the game from (?<from>\d+\.\d+\.\d+) to (?<to>\d+\.\d+\.\d+)/),

	    MessageParser.new(:died, /^Annihilated by (?<cause>.+)/),
	    MessageParser.new(:died, /^Blown up by (?<cause>.+)/),
	    MessageParser.new(:died, /^Demolished by (?<cause>.+)/),
	    MessageParser.new(:died, /^Mangled by (?<cause>.+)/),
	    MessageParser.new(:died, /^Slain by (?<cause>.+)/),
	    MessageParser.new(:died, /^Killed( from afar)? by (?<cause>[ \w]+)(... set off by themselves)?/),
	    MessageParser.new(:died, /^Rolled over by (?<cause>.+)/),
	    MessageParser.new(:died, /^Annihilated by (?<cause>.+)/),
	    MessageParser.new(:died, /^Succumbed to (?<cause>.+)'s (sting|poison)/),
			MessageParser.new(:died, /^Killed themsel(f|ves) with bad targetting/, cause: 'self'),
	    MessageParser.new(:died, /^Quit the game/, cause: 'self'),
	    MessageParser.new(:died, /^Starved to death/, cause: 'starvation'),
			MessageParser.new(:died, /^Was drained of all life/, cause: 'drained'),

	    MessageParser.new(:escaped, /^Safely got out of the dungeon./),

			MessageParser.new(:noticed_monster, /^Noticed\s(\d+|[aA]n?\s+)?(?<monster>[ a-zA-Z]+)/),

			MessageParser.new(:killed_monster, /^Defeated (?<monster>[' \w]+)/),
			MessageParser.new(:killed_monster, /^Killed (?<monster>[' \w]+)/),

# UNTESTED
			MessageParser.new(:gained_ally, /^Gained (?<monster>[ \w]+) as an ally/),
			MessageParser.new(:lost_ally, /^Your ally (?<monster>[ \w]+)? died/),

			MessageParser.new(:paralysed, /^Paralysed by (?<monster>[ \w]+) for \d+ turns/),
			MessageParser.new(:shot, /^Shot with (?<with>[ \w]+) by (?<monster>[ \w]+)/),
			MessageParser.new(:shot, /^Splashed by ?(?<monster>a jelly)?(\'s)? (?<with>acid)/),

			MessageParser.new(:xp, /^Reached XP level (?<level>\d{1,2})/, skill: 'level'),
			MessageParser.new(:xp, /^Reached skill( level)? (?<level>\d{1,2}) in (?<skill>\w+)/),

			MessageParser.new(:learned_spell, /^Learned a level (\d) spell: (?<spell>[ \w]+)/),

			MessageParser.new(:gained_mutation, /^Gained mutation\: (?<mutation>[ \w\d\+\-\(\),]+).( [mutagenic glow])?/),
			MessageParser.new(:lost_mutation, /^Lost mutation\: (?<mutation>[ \w\d\+\-\(\),]+).( [potion of cure mutation])?/),

	    # # religion
	    # [:religion, /^Found an? [ \w-]+ altar of ([ \w]+)./],
	    # [:religion, /^Became a worshipper of ([ \w]+)( the [\w]+)?/],
	    # [:religion, /^Fell from the grace of ([ \w]+)/],
	    # [:religion, /^Acquired ([ \w]+)\'s (\w+) power/],
	    # [:religion, /^([ \w]+) protects you from harm!/],
	    # [:religion, /^Offered knowledge of (.+) by Vehumet./],
	    # [:religion, /^Received a gift from ([ \w]+)/],
	    # [:religion, /^Was placed under penance by (.+)/],
	    # [:religion, /^Was forgiven by (.+)/],

	    # # place
	    # [:place, /^Entered Level (\d{1,2}) of ([ \w]+)/],
	    # [:place, /^Found a staircase to the ([ \w]+)./],
	    # [:place, /^Found a ([ \w]+)./], # feature
	    # [:place, /^Found (.+)./], # shop
	    # [:place, /^You fall through a shaft( for (\d) floors)?!/],
	    # [:place, /^You paid a toll of (\d+) gold to enter a ziggurat./],
	    # [:place, /^You pass through the gate./],

	    # # items
	    # [:items, /^Got ([ \w]+)/],
	    # [:items, /^Identified ([ \d\w\{\}\+\-\']+)( \(You found it on level (\d{1,2}) of ([ \w]+)\))?/],
	    # [:items, /^Bought ([ \d\w\{\}\+\-\',\(\)]+) for (\d+) gold pieces/],

	    # [:void, /^Entered (.+)/],
	    # [:void, /^Escaped (.+)/],
	    # [:void, /^Banished ([ \w]+)/],
	    # [:void, /^Cast into the Abyss \((.+)\)/],
	    # [:void, /^Voluntarily entered the Abyss./],
	    # [:void, /^You are cast into the Abyss!/],

			MessageParser.new(:unknown, /.*/),

		].each do |message_parser|
			result = message_parser.parse(message)
			return result if result
		end

  end


end