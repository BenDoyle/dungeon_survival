require 'test_helper'

class MonsterParserTest < Test::Unit::TestCase

	def test_row1
		row1 = "MONS_DRACONIAN, 'd', BROWN, \"draconian\","

		elements = MonstersRow1Parser.new.parse(row1).elements

		assert_equal 'MONS_DRACONIAN', elements[0].text_value
		assert_equal 'd', elements[2].elements[1].text_value
		assert_equal 'BROWN', elements[4].text_value
		assert_equal 'draconian', elements[6].elements[1].text_value
	end

	def test_row2
		row2 = "M_SENSE_INVIS | M_WARM_BLOOD | M_BATTY | M_NO_POLY_TO,"

		elements = MonstersRow2Parser.new.parse(row2).elements

		assert_equal 'M_SENSE_INVIS', elements[0].text_value
		assert_equal 'M_WARM_BLOOD', elements[1].elements[0].elements[3].text_value
		assert_equal 'M_BATTY', elements[1].elements[1].elements[3].text_value
		assert_equal 'M_NO_POLY_TO', elements[1].elements[2].elements[3].text_value
	end

	def test_row2_single
		row2 = "M_SENSE_INVIS,"

		elements = MonstersRow2Parser.new.parse(row2).elements

		assert_equal 'M_SENSE_INVIS', elements[0].text_value
	end
end
