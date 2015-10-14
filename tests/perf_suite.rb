require 'benchmark/ips'
require_relative 'board_test'

class PerfSuite
  TURNS = ['x', 'o'].cycle
  INPUTS = [
    ".........",
    "x.o.xxx..",
    "..ooo....",
    "oo.oo....",
    "o.o...o.o",
    "oxoxoxxox",
    "ooo......",
    "...xxx...",
    "......ooo",
    "x..x..x..",
  ]
  POSITIONS = 1.upto(9).cycle

  def initialize(*board_classes)
    @board_classes = Array(board_classes)
  end

  def run(run_benchmarks: true, detailed_benchmarks: false)
    tests.each &:perform
    benchmark_playthroughs if run_benchmarks
    benchmark_methods if detailed_benchmarks
  end

private

  def tests
    @tests ||= @board_classes.map { |c| BoardTest.new c }
  end

  def benchmark_playthroughs
    puts "==> Benchmarking playthrough"
    moves = 1.upto(9).to_a.shuffle
    benchmark("Playthrough") { |klass| playthrough klass, moves }
  end

  def benchmark(type, &block)
    Benchmark.ips do |x|
      x.config(time: 1, warmup: 0.5)

      @board_classes.each do |klass|
        x.report("#{klass.name.gsub 'Board', ''} #{type}") { yield klass }
      end
      x.compare!
    end
  end

  def playthrough(board_klass, moves)
    moves = 1.upto(9).to_a.shuffle
    b = board_klass.new
    until b.winner || b.draw? do
      b.mark_turn TURNS.next, moves.pop
    end
  end

  def benchmark_methods
    puts "==> Benchmarking methods"
    setups = INPUTS.cycle

    loaded_boards = Hash[
      @board_classes.map { |k| [k, k.new.tap {|b| b.load("x.o.xxx..")}] }
    ]

    benchmark("#load") { |klass| klass.new.load "x.o.xxx.." }
    benchmark("#mark_turn") { |klass| benchmark_mark_turn loaded_boards[klass].dup }
    benchmark('#winner') { |klass| loaded_boards[klass].winner }
    benchmark('#finished?') { |klass| loaded_boards[klass].finished? }
  end

  def benchmark_mark_turn(board)
    board.mark_turn 'o', POSITIONS.next
  rescue Board::InvalidPlacementError
  end

end
