class Board
  def initialize
    @state = []
  end
  InvalidPlacementError = Class.new StandardError

  # Takes a simple string like e.g.
  #   "xoxoxooo."
  #   "x..o...x."
  def load(input)
	@state = input.chars
  end

  # Records a player's turn.
  #  `player` will either be 'x' or 'o'
  #  `position` will be a number from 1-9 corresponding to the grid
  #     1 | 2 | 3
  #     --+---+--
  #     4 | 5 | 6
  #     --+---+--
  #     7 | 8 | 9
  # Needs to raise InvalidPlacementError if the position is already filled
  def mark_turn(player, position)
    if (state[position - 1] != '.')
		raise InvalidPlacementError
	else
		@state[position - 1] = player
	end
  end

  # True if all the squares have been filled
  def finished?
	state.none? { |c| c == "."}
  end

  # returns 'x', 'o' or `nil` for a draw or an incomplete board
  def winner
    wincheck = state.each_slice(3).to_a.transpose
    return "x" if wincheck.map { |r| r.all? { |c| c == "x"} }.any?
    return "o" if wincheck.map { |r| r.all? { |c| c == "o"} }.any?
    wincheck = state.each_slice(3).to_a
    return "x" if wincheck.map { |r| r.all? { |c| c == "x"} }.any?
    return "o" if wincheck.map { |r| r.all? { |c| c == "o"} }.any?
    return "x" if state[0] == state[4] && state[4] == state[8] && state[8] == "x"
    return "x" if state[2] == state[4] && state[4] == state[6] && state[6] == "x"
    return "o" if state[0] == state[4] && state[4] == state[8] && state[8] == "o"
    return "o" if state[2] == state[4] && state[4] == state[6] && state[6] == "o"
  end

  def draw?
    finished? && ! winner
  end

  def to_s
    (board_in_2d.map {|s| s.join(" | ") }.join("\n--+---+--\n") + "\n").tr '.', ' '
  end

private
	attr_accessor :state
  # This is optional and isn't tested
  # This needs to be a 2D array
  # e.g. [["x", "o", "x"], ["o", "x", "o"], ["o", "o", " "]]
  def board_in_2d
    raise NotImplementedError
  end

end
