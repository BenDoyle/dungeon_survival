require 'time'
require 'test/unit'
require 'treetop'

Treetop.load File.join(File.dirname(__FILE__), '..', 'lib', 'parsers', 'basic.treetop')

Dir[File.join(File.dirname(__FILE__), '..', 'lib', 'parsers', 'monster', '*.rb')].each do |file|
  require file
end

Dir[File.join(File.dirname(__FILE__), '..', 'lib', 'parsers', 'monster', '*.treetop')].each do |file|
  Treetop.load file
end
