require_relative "board"

class BitmapBoard < Board
  FINISHED_BOARD_VALUE = 0b111_111_111

  WINNING_VALUES = [
    0b111_000_000,
    0b000_111_000,
    0b000_000_111,
    0b100_100_100,
    0b010_010_010,
    0b001_001_001,
    0b100_010_001,
    0b001_010_100,
  ]

  def initialize
    @positions = {
      'o' => 0,
      'x' => 0,
    }
  end

  def load(input)
    @positions['x'] = @positions['o'] = 0
    input.chars.each_with_index do |mark, i|
      next if mark == "."
      @positions[mark] += 2 ** i
    end
    self
  end

  def mark_turn(player, position)
    value = 2 ** (position-1)
    raise InvalidPlacementError, "#{position} is already filled" if combined_positions & value > 0
    @positions[player] += value
    self
  end

  def finished?
    combined_positions == FINISHED_BOARD_VALUE
  end

  def winner
    @positions.keys.find do |player|
      WINNING_VALUES.any? { |v| @positions[player] & v == v }
    end
  end

private

  def combined_positions
    @positions['x'] | @positions['o']
  end

  def board_in_2d
    0.upto(8).map do |i|
      value = 2 ** i
      if @positions['o'] & value > 0
        "o"
      elsif @positions['x'] & value > 0
        "x"
      else
        " "
      end
    end.each_slice(3)
  end

end
