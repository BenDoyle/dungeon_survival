# require File.join(File.dirname(__FILE__), 'extract.rb')
$LOAD_PATH << './lib'
require 'extract.rb'

File.open('out.csv', 'w') do |line|
  Dir[File.join(ARGV[0],'*.txt')].each_with_index do |file, index|
    unless file.scan(/morgue-(\w+)-(\d{8}-\d{6})\.(\w{3})/).empty?
      extract = Extract.new
      extract.parse_morgue_file(file)
      # puts extract.stats.inspect
      # total += extract.stats[:game_duration_seconds]
      # puts "#{index + 1}, #{total / (60*60*24).to_f} days"

      line.puts extract.stats[:game_duration_seconds] / (60*60).to_f
    end
  end
end