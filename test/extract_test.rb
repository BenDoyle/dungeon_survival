require 'test_helper'

class ExtractTest < Test::Unit::TestCase

  def test_fail
    morgue_file = File.join(File.dirname(__FILE__),'..','data','morgue-Crag-20140319-212609.txt')
    extracor = Extract()
    extractor.parse_morgue_file(morgue_file)

    puts extractor.stats.inspect

    assert False

  end

end