require 'test_helper'

class WorkflowTest < Test::Unit::TestCase

	def parser
		@parser ||= MonstersParser.new
	end

	def test_row1
		row1 = "MONS_DRACONIAN, 'd', BROWN, \"draconian\","
		
		elements = parser.parse(row1).elements
		
		assert_equal 'MONS_DRACONIAN', elements[0].text_value
		assert_equal 'd', elements[2].elements[1].text_value
		assert_equal 'BROWN', elements[4].text_value
		assert_equal 'draconian', elements[6].elements[1].text_value
	end

end
