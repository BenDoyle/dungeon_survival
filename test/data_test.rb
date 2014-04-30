require 'test_helper'

class DataTest < Test::Unit::TestCase
	
  def file_handles
    Dir[File.join(File.dirname(__FILE__),'..','..','dcss_morgue','*.txt')]
  end


  def test_parsers
		w = Workflow.new

    file_handles.select{|file|w.log_filter(file)}.each do |file|
      
      lines = w.read_file(file)
      
      version = w.get_mode_and_version(lines.first)

      # puts version

    end

	end
end
