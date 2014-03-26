class Extract
  attr_reader :stats, :monsters, :events

  def initialize
    @stats    = {}
    @monsters = []
    @events   = []
  end

  def parse_morgue_file(morgue_file)
    @stats[:name], @stats[:timestamp], @stats[:type] = morgue_file.scan(/morgue-(\w+)-(\d{8}-\d{6})\.(\w{3})/).first
    File.open(morgue_file, "r") do |file|
      state = nil
      begin
        line  = file.gets
        break unless line
        if line.ascii_only?
          line = line.strip
          unless line.empty?
            state = new_state(state, line)
            parse_line(state, line)
          end
        end
      end while true
    end
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

  def parse_line(state, line)
    case state
    when :stats
      @stats.merge!(parse_stats(line))
    when :monster
      @monsters << parse_monster(line)
    when :events
      @events << parse_events(line)
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
    turn, branch, level, message = line.scan(/^(\d+)\s+\|\s+(\w+):?(\d{1,2})?\s+\|\s+(.+)/).first
    {
      turn: turn.to_i,
      branch: branch,
      level: [level.to_i, 1].max,
      message: message
    }
  end
end