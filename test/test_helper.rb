require 'time'
require 'test/unit'
require 'treetop'

Treetop.load File.join(File.dirname(__FILE__), '..', 'lib', 'parsers', 'monsters.treetop')
Treetop.load File.join(File.dirname(__FILE__), '..', 'lib', 'parsers', 'monsters_row1.treetop')
Treetop.load File.join(File.dirname(__FILE__), '..', 'lib', 'parsers', 'monsters_row2.treetop')
