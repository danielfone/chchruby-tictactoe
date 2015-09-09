#! /usr/bin/env ruby

require 'pry'

require_relative "./bitmap_board"
require_relative "./fast_board"
require_relative "./slow_board"
require_relative "./string_board"
require_relative "./array_board"
require_relative "./test_suite"

s = TestSuite.new BitmapBoard, FastBoard, SlowBoard, StringBoard
s.run
