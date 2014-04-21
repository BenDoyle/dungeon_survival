$LOAD_PATH << './lib'
require 'extract.rb'



messages = []

File.open('out.csv', 'w') do |line|
  Dir[File.join(ARGV[0],'*.txt')].each_with_index do |file, index|
    unless file.scan(/morgue-(\w+)-(\d{8}-\d{6})\.(\w{3})/).empty?
      extract = Extract.new
      extract.parse_morgue_file(file)
    end
  end
end

