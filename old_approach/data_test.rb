require 'test_helper'

class DataTest < Test::Unit::TestCase
	
  def file_handles
    Dir[File.join(File.dirname(__FILE__),'..','..','dcss_morgue','*.txt')]
  end

  def test_parsers
		w = Workflow.new
    events = []

    file_handles.select{|file|w.log_filter(file)}.each do |file|
      lines = w.read_file(file)
      events += w.get_all_events(lines)
    end

    puts events.size

    puts events.map{|e|w.parse_message(e[3])}.select{|e|e[:type] == :unknown}.map{|e|e[:message]}.sort

	end
end
