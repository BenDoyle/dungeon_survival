class Extract
  attr_reader :summaries, :errors, :stats, :monsters, :events, :errors

  def initialize(input = nil, output = {}, error = nil)
    infiles  ||= '/Users/ben/Library/Application Support/Dungeon\ Crawl\ Stone\ Soup/morgue/*.txt'
    infiles    = Dir[infiles]
    error    ||= 'errors.json'
    outfiles =   {
      characters: 'characters.json',
      monsters:   'monsters.json',
      events:     'events.json'
    }.merge(output)

    @errors = []
    @summaries = []
    infiles.each_with_index do |file, index|
      unless file.scan(/morgue-(\w+)-(\d{8}-\d{6})\.(\w{3})/).empty?
        @summaries << parse_file(file)
      end
    end

    @summaries
  end

  def error_checks
    @summaries.each do |summary|
      missing_stats = [:name, :timestamp, :version, :species_background, :start_date, :game_duration_seconds, :game_duration_turns] - summary[:stats].keys
      unless missing_stats.empty?
        puts summary[:stats].keys.inspect 
        @errors << "[stats missing for] #{summary[:stats][:morguefile]}: #{missing_stats}" 
      end
    end
  end

  def update_summay_with_filename(summary, filename)
    summary[:stats] ||= {}
    summary[:stats][:morguefile] = filename
    summary[:stats][:name], summary[:stats][:timestamp] = filename.scan(/morgue-(\w+)-(\d{8}-\d{6})\.txt/).first
  end

  def parse_file(filename)
    summary = {}
    update_summay_with_filename(summary, filename)
    File.open(filename, "r") do |file|
      state = nil
      begin
        line  = file.gets
        break unless line
        if line.ascii_only?
          line = line.strip
          unless line.empty?
            state = new_state(state, line)
            parse_line(summary, state, line)
          end
        end
      end while true
    end
    summary
  end

  def new_state(state, line)
    return :finished unless line
    return state unless line.ascii_only?
    return :stats unless state

    return :inventory if line =~ /^Inventory:/
    return :skills if line =~ /^   Skills:/
    return :spells if line =~ /You had \d+ spell levels? left/
    return :overview if line =~ /Dungeon Overview and Level Annotations/
    return :abilities if line =~ /Innate Abilities, Weirdness & Mutations/
    return :final_turns if line =~ /Message History/
    return :monster_header if line == 'Vanquished Creatures'
    return :monster_summary if line =~ /\d+ creatures? vanquished./
    return :events_header if line == 'Notes'
    if line == '--------------------------------------------------------------' && state == :events_header
      return :events_line
    end
    return :action_summary if line =~ /Action\s+\|/

    return :monster if state == :monster_header
    return :events  if state == :events_line

    return state
  end

  def parse_line(summary, state, line)
    summary[:monsters] ||= []
    summary[:events] ||= []
    case state
    when :stats
      summary[:stats].merge!(parse_stats(line))
    when :monster
      summary[:monsters] << parse_monster(line)
    when :events
      summary[:events] << parse_events(line)
    end
  end

  def parse_stats(line)
    version_re = /Dungeon Crawl Stone Soup version ([\.\d]+)/
    if line =~ version_re
      return {version: line.scan(version_re).first.first}
    end

    began_re = /Began as a ([ \w]+) on ([ \w,]+)./
    if line =~ began_re
      values = line.scan(began_re).first
      return {
        species_background: values[0],
        start_date:         values[1]
      }
    end

    duration_re = /game lasted (\d?)d?a?y? ?(\d{2}):(\d{2}):(\d{2}) \((\d+) turns\)./
    if line =~ duration_re
      values = line.scan(duration_re).first
      return {
        game_duration_seconds: values[0].to_i*3600*24 + values[1].to_i*3600 + values[2].to_i*60 + values[3].to_i,
        game_duration_turns: values[4].to_i
      }
    end

    return {}
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

  def parse_events(line)
    turn, branch, level, message = line.scan(/^(\d+)\s+\|\s+(\w+):?(\d{1,2}|\$)?\s+\|\s+(.+)/).first
    level ||= 1
    level ==  '$' ? 0 : level
    level = level.to_i
    {
      turn: turn.to_i,
      branch: branch,
      level: level,
      message: message
    }
  end

  def parse_message(message)
    case message

    # game
    when /^(\w+), the ([ \w]+), began the quest for the Orb./
    when /^Upgraded the game from (\d+\.\d+\.\d+) to (\d+\.\d+\.\d+)/

    # died
    when /^Annihilated by (.+)/
    when /^Blown up by (.+)/
    when /^Demolished by (.+)/
    when /^Mangled by (.+)/
    when /^Slain by (.+)/
    when /^Killed( from afar)? by an? ([ \w]+)(... set off by themselves)?/
    when /^Rolled over by (.+)/
    when /^Killed themsel(f|ves) with bad targetting/
    when /^Quit the game/
    when /^Safely got out of the dungeon./
    when /^Starved to death/
    when /^Succumbed to (.+) (sting|poison)/
    when /^Was drained of all life/

    # monsters
    when /^Noticed\s(\d+|An?\s+)?([ a-zA-Z]+)/
    when /^Defeated ([ \w]+)'s ghost/
    when /^Defeated ([ \w]+)/
    when /^Killed ([ \w]+)'s ghost/
    when /^Killed ([ \w]+)/
    when /^Gained ([ \w]+) as an ally/
    when /^Paralysed by ([ \w]+) for \d+ turns/
    when /^Shot with ([ \w]+) by ([ \w]+)/
    when /^Splashed by( a jelly\'s)? acid/
    when /^Your ally ([ \w]+)? died/

    # character
    when /^Reached XP level (\d{1,2})/
    when /^Reached skill( level)? (\d{1,2}) in (\w+)/
    when /^Learned a level (\d) spell: ([ \w]+)/
    when /^Gained mutation\: ([ \w\d\+\-\(\),]+).( [mutagenic glow])?/
    when /^Lost mutation\: ([ \w\d\+\-\(\),]+).( [potion of cure mutation])?/

    # religion
    when /^Found an? [ \w-]+ altar of ([ \w]+)./
    when /^Became a worshipper of ([ \w]+)( the [\w]+)?/
    when /^Fell from the grace of ([ \w]+)/
    when /^Acquired ([ \w]+)\'s (\w+) power/
    when /^([ \w]+) protects you from harm!/
    when /^Offered knowledge of (.+) by Vehumet./
    when /^Received a gift from ([ \w]+)/
    when /^Was placed under penance by (.+)/
    when /^Was forgiven by (.+)/

    # place
    when /^Entered Level (\d{1,2}) of ([ \w]+)/
    when /^Found a staircase to the ([ \w]+)./
    when /^Found a ([ \w]+)./ # feature
    when /^Found (.+)./ # shop
    when /^You fall through a shaft( for (\d) floors)?!/
    when /^You paid a toll of (\d+) gold to enter a ziggurat./
    when /^You pass through the gate./

    # items
    when /^Got ([ \w]+)/
    when /^Identified ([ \d\w\{\}\+\-\']+)( \(You found it on level (\d{1,2}) of ([ \w]+)\))?/
    when /^Bought ([ \d\w\{\}\+\-\',\(\)]+) for (\d+) gold pieces/

    # abyss / pandemonium
    when /^Entered (.+)/
    when /^Escaped (.+)/
    when /^Banished ([ \w]+)/
    when /^Cast into the Abyss \((.+)\)/
    when /^Voluntarily entered the Abyss./
    when /^You are cast into the Abyss!/

    else
      puts message
    end
  end



end