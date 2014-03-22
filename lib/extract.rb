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
        line = line.strip

        if line.ascii_only? || !line.empty?
          state = new_state(state, line)
          parse_line(state, line)
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
    return :monster_summary if line =~ /\d+ creatures vanquished./
    return :events if line == 'Notes'
    return :action_summary if line =~ /Action\s+\|\| total/

    return :monster if state = :monster_header

    return state
  end

  def parse_line(state, line)
    case state
    when :stats
      parse_stats(line)
    when :monsters
      parse_monsters(line)
    when :events
      parse_events(line)
    end
  end

  EVENT              = /^\s+(\d+)\s+\|\s+(\w+):(\d{1,2})\s+\|\s+(.+)/


  def parse_stats(line)
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
  end

    #   case line
    # when SINGULAR_MONSTER
    #   monster = line.scan(SINGULAR_MONSTER).first
    #   @monsters << {number: 1, monster: monster[1].strip} unless monster[1].strip.empty?
    # when PLURAL_MONSTER
    #   monster = line.scan(PLURAL_MONSTER).first
    #   @monsters << {number: monster[0].strip.to_i, monster: monster[1].strip} unless monster[1].strip.empty?
    # when EVENT
    #   turn, branch, level, message = line.scan(EVENT).first
    #   @events << {turn: turn, branch: branch, level: level, message: message}
    # end



end