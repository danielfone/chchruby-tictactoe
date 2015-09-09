require 'benchmark/ips'

class TestSuite
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

  def initialize(*board_classes, run_benchmarks: false, detailed_benchmarks: false)
    @board_classes = Array(board_classes)
    @detailed_benchmarks = detailed_benchmarks
    @run_benchmarks = run_benchmarks
  end

  def run
    tests.each &:perform
    benchmark_playthroughs if @run_benchmarks
    benchmark_methods if @detailed_benchmarks
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

class BoardTest

  def initialize(board_class)
    @board = board_class.new
  end

  def perform
    puts "Testing #{@board.class.name}..."
    @board.load 'xoxoxooo.'
    fail_expectation "board shouldn't be finished" if @board.finished?
    fail_expectation "board shouldn't have a winner" if @board.winner

    fail_expectation "board doesn't raise InvalidPlacementError" unless raises? Board::InvalidPlacementError do
      @board.mark_turn "x", 1
    end

    @board.mark_turn "x", 9
    fail_expectation "board output doesn't match" unless @board.to_s == <<-BOARD
x | o | x
--+---+--
o | x | o
--+---+--
o | o | x
BOARD
    fail_expectation "board should be finished" if ! @board.finished?
    fail_expectation "x should be the winner" unless @board.winner == 'x'

    test_victory "x.o.xxx..", nil
    test_victory "..ooo....", nil
    test_victory "oo.oo....", nil
    test_victory "o.o...o.o", nil
    test_victory "oxoxoxxox", nil

    test_victory "ooo......", 'o'
    test_victory "...xxx...", 'x'
    test_victory "......ooo", 'o'
    test_victory "x..x..x..", 'x'
    test_victory ".o..o..o.", 'o'
    test_victory "..x..x..x", 'x'
    test_victory "o...o...o", 'o'
    test_victory "..x.x.x..", 'x'
  end

private

  def fail_expectation(message, expectation="Exceptation wasn't met")
    fail "#{expectation}\n#{message}"
  end

  def raises?(error_klass)
    rescued = false
    begin
      yield
    rescue error_klass
      rescued = true
    end
    rescued
  end

  def test_victory(state, expected)
    @board.load state
    actual = @board.winner

    if actual != expected
      fail_expectation "Victory check failed",
       "Expected winner to be #{expected.inspect}\n"+
       "Got #{actual.inspect}\n"+
       "#{@board}\n"
    end
  end
end
