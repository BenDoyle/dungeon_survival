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
    values = line.scan(/^(\d+|An?\s+)?([ a-zA-Z]+)/).first
    number = values[0].to_i
    number = 1 if number.zero?
    type   = values[1].strip
    type   = type[0..-2] if number > 1
    {
      number: number,
      type:   type
    }
  end

	# def get_monster_lines(lines)
	# 	out_lines = []
	# 	lines.each do |line|
	# 		if line =~ /^Vanquished Creatures/
	# 			monster = true
	# 		end
	# 		if monster
	# 			if line.strip =~ /Grand Total/
	# 				break
	# 			end
	# 			if 
	# 		end
	# 	end
	# 	lines
	# end

end