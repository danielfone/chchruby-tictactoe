#
# I wish I had time to figure out how to run rspec properly :(
#
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

  def fail_expectation(message, expectation="Expectation wasn't met")
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
