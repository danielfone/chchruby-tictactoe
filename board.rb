class Board
  InvalidPlacementError = Class.new StandardError

  # Takes a simple string like e.g.
  #   "xoxoxooo."
  #   "x..o...x."
  def load(input)
    raise NotImplementedError
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
    raise InvalidPlacementError
  end

  def draw?
    finished? && ! winner
  end

  # True if all the squares have been filled
  def finished?
    raise NotImplementedError
  end

  # returns 'x', 'o' or `nil` for a draw or an incomplete board
  def winner
    raise NotImplementedError
  end

  def to_s
    (board_in_2d.map {|s| s.join(" | ") }.join("\n--+---+--\n") + "\n").tr '.', ' '
  end

private

  # This needs to be a 2D array
  # e.g. [["x", "o", "x"], ["o", "x", "o"], ["o", "o", " "]]
  def board_in_2d
    raise NotImplementedError
  end

end
