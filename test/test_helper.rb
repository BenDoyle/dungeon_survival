require 'time'
require 'test/unit'
require 'treetop'

require File.join(File.dirname(__FILE__),'..','lib','workflow.rb')
require File.join(File.dirname(__FILE__),'..','lib','message_parser.rb')

Treetop.load File.join(File.dirname(__FILE__),'..','lib','monsters.treetop')
