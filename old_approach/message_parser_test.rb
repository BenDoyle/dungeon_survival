require 'test_helper'

class MessageParserTest < Test::Unit::TestCase
	def test_no_match
		assert_equal nil, MessageParser.new('foo', /(?<baz>bar)/).parse("beep")
	end

	def test_simple_match
		mp = MessageParser.new('foo', /(?<baz>bar)/)
		message = "bar"
		expected = {
			type: 'foo',
			message: message,
			baz: "bar"
		}
		assert_equal expected, mp.parse(message)
	end

	def test_match_with_default_absent
		mp = MessageParser.new('foo', /(?<baz>bar)(?<bop>bop)?/, bop: 'fnord')
		message = "bar"
		expected = {
			type: 'foo',
			message: message,
			baz: "bar",
			bop: "fnord"
		}
		assert_equal expected, mp.parse(message)
	end

	def test_match_with_default_present
		mp = MessageParser.new('foo', /(?<baz>bar)(?<bop>bop)?/, bop: 'fnord')
		message = "barbop"
		expected = {
			type: 'foo',
			message: message,
			baz: "bar",
			bop: "bop"
		}
		assert_equal expected, mp.parse(message)
	end

	def test_match_with_default_unspecified
		mp = MessageParser.new('foo', /(?<baz>bar)/, bop: 'fnord')
		message = "barbop"
		expected = {
			type: 'foo',
			message: message,
			baz: "bar",
			bop: "fnord"
		}
		assert_equal expected, mp.parse(message)
	end

end
