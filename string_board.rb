require_relative "board"

class StringBoard < Board

  def initialize
    @positions = "." * 9
  end

  def load(marks)
    @positions = marks
  end

  def mark_turn(player, position)
    index = position - 1
    raise InvalidPlacementError if @positions[index] != '.'
    @positions[index] = player
  end

  def finished?
    !@positions['.']
  end

  def winner
    ['x', 'o'].each do |player|
      return player if @positions =~ /^.{3}*#{player}{3}/ # horizontal
      return player if @positions =~ /#{player}...#{player}...#{player}/ # diagonal
      return player if @positions =~ /..#{player}.#{player}.#{player}../ # diagonal
      return player if @positions =~ /#{player}.{2}#{player}.{2}#{player}/ # vertical
    end
    nil
  end

private

  def board_in_2d
    @positions.chars.each_slice(3)
  end
end
