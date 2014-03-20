class Extract
  SINGULAR_MONSTER   = /^\s{2}(An?\s+)?([a-zA-Z_\s]+)\(\w+:\d{1,2}\)/
  PLURAL_MONSTER     = /^\s{2}(\d+)\s([a-zA-Z_\s]+)(\(\w+:\d{1,2}\))?/
  EVENT              = /^\s+(\d+)\s+\|\s+(\w+):(\d{1,2})\s+\|\s+(.+)/

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
      do
        line  = file.gets
        state = new_state(state, line)
        parse_line(state, line)
      while(state != :finished)
    end
  end

  def new_state(state, line)
    return :finished unless line
    return state if line.ascii_only?

    return state
  end

  def parse_line(state, line)
    return nil unless line.ascii_only?

    case line
    when SINGULAR_MONSTER
      monster = line.scan(SINGULAR_MONSTER).first
      @monsters << {number: 1, monster: monster[1].strip} unless monster[1].strip.empty?
    when PLURAL_MONSTER
      monster = line.scan(PLURAL_MONSTER).first
      @monsters << {number: monster[0].strip.to_i, monster: monster[1].strip} unless monster[1].strip.empty?
    when EVENT
      turn, branch, level, message = line.scan(EVENT).first
      @events << {turn: turn, branch: branch, level: level, message: message}
    end
  end
end