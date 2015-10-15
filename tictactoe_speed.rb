#! /usr/bin/env ruby

require_relative "./tests/perf_suite"
require_relative "./boards/fast_board"
require_relative "./boards/slow_board"
# Load your board class here

s = PerfSuite.new FastBoard, SlowBoard, Board # Add it to this list
s.run # detailed_benchmarks: true
