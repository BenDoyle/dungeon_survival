def parse_morgue_file2(morgue_file)
  singular_monster_regex   = /^\s{2}(An?\s+)?([a-zA-Z_\s]+)\(\w+:\d{1,2}\)/
  plural_monster_regex     = /^\s{2}(\d+)\s([a-zA-Z_\s]+)(\(\w+:\d{1,2}\))?/
  event_regex              = /^(\d+)\s+\|\s+(\w+):(\d{1,2})\s+\|\s+(.+)/

  monsters = []
  events   = []

  File.open(morgue_file, "r") do |file|
    while(line = file.gets)
      if line.ascii_only?
        case line
        when singular_monster_regex
          monster = line.scan(singular_monster_regex).first
          monsters << {number: 1, monster: monster[1].strip} unless monster[1].strip.empty?
        when plural_monster_regex
          monster = line.scan(plural_monster_regex).first
          monsters << {number: monster[0].strip.to_i, monster: monster[1].strip} unless monster[1].strip.empty?
        when event_regex
          turn, branch, level, message = line.scan(event_regex).first
          events << {turn: turn, branch: branch, level: level, message: message}
        end
      end
    end
  end
  [events, monsters]
end


morgue_files = Dir["#{ARGV[0]}/*"].entries
games = []

morgue_files.each do |morgue_file|
  name, timestamp, type = morgue_file.scan(/morgue-(\w+)-(\d{8}-\d{6})\.(\w{3})/).first
  if name && timestamp && type == 'txt'
    notes, monsters = parse_morgue_file2(morgue_file)
    games << {name: name, timestamp: timestamp, notes: notes, monsters: monsters} if notes || monsters
  end
end

puts games[2][:name]
puts games[2][:timestamp]
puts games[2][:notes]
puts games[2][:monsters]
