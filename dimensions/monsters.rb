def read_file(filename)
	# some of the maps have non-ascii characters, which ruby doesn't like
	File.readlines(filename).select{|line|line.ascii_only?}.map{|line|line.gsub(/\n/, "")}
end

def parse_content(content)
  monsters = []
  monster = {}
  data = false

  content.each do |line|
    data = true if line =~ /\/\/ Real monsters begin here {dlb}:/

    if line[0] == '}'
      monsters << monster
      monster = {}
    end

    


  end

  monsters
end






monster_files = Dir[File.join(File.dirname(__FILE__),'..','data','**','mon-data.h')]

monster_files.each do |monster_file|
  version = monster_file.split('/')[-2]
  content = read_file(monster_file)

  monsters = parse_content(content)
  


end


