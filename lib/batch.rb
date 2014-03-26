$LOAD_PATH << './lib'
require 'extract.rb'


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

messages = []

File.open('out.csv', 'w') do |line|
  Dir[File.join(ARGV[0],'*.txt')].each_with_index do |file, index|
    unless file.scan(/morgue-(\w+)-(\d{8}-\d{6})\.(\w{3})/).empty?
      extract = Extract.new
      extract.parse_morgue_file(file)
      messages += extract.events.map{|m|m[:message]}
    end
  end
end

messages.sort.each do |m|
  parse_message(m)
end
