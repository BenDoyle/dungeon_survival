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
				out[key] ||= []
				out[key]  <<  parse_monster(line)
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

end