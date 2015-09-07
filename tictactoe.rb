#! /usr/bin/env ruby

require 'pry'

require_relative "./bitmap_board"
require_relative "./string_board"
require_relative "./test_suite"

s = TestSuite.new BitmapBoard, StringBoard#, detailed: true
s.run
